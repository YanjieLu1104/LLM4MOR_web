## Problem background

The model represents an **open-stacks production sequencing problem**. There are \(p\) products and \(c\) customers. The binary input `orders[i,j]` indicates whether customer \(i\) orders product \(j\). Every product must be produced exactly once.

A customer’s stack can be interpreted as temporary storage for that customer’s partially completed order. It opens when the first requested product is produced and closes after the last requested product is produced. At a production step, both newly opened stacks and stacks receiving their final product count as open. The aim is to sequence products to **minimize the largest number of simultaneously open stacks**, thereby reducing peak storage or handling requirements.

## Original formulation

The original model declares \(p+c(p+1)+1\) integer decision variables:

- **`s[t]`**: the product produced at position \(t\), with domain \(1,\ldots,p\).
- **`o[i,t]`**: the number of customer \(i\)’s requested products completed after position \(t\), including position zero.
- **`objective`**: the peak number of open stacks, with domain \(0,\ldots,c\).

The derived parameter `norders[i]` is the total number of products requested by customer \(i\).

The constraints consist of:

1. An **all-different constraint** on `s`, making it a permutation of the products.
2. \(c\) initial conditions, `o[i,0] = 0`.
3. \(cp\) cumulative updates:
   \[
   o_{i,t}=o_{i,t-1}+\mathrm{orders}_{i,s_t}.
   \]
4. An exact definition of the objective:
   \[
   \mathrm{objective}
   =
   \max_{t=1,\ldots,p}
   \sum_{i=1}^{c}
   \mathbf{1}\!\left[o_{i,t-1}<n_i\ \land\ o_{i,t}>0\right],
   \]
   where \(n_i=\mathrm{norders}[i]\).

The activity condition means that the customer was not already finished before the step and has started by the end of the step. Customers with no requested products never contribute. The optimization direction is **minimization**.

## Reformulation and justification

### Binary assignment formulation for the schedule

The reformulation introduces \(p^2\) binary variables \(x_{t,k}\), indicating whether product \(k\) is produced at position \(t\), with
\[
\sum_k x_{t,k}=1,
\qquad
\sum_t x_{t,k}=1.
\]
The original schedule remains available through
\[
s_t=\sum_k kx_{t,k}.
\]

These equations are equivalent to the original permutation constraint: each position contains exactly one product, and each product appears exactly once. Conversely, every original permutation determines a unique assignment matrix.

The cumulative update becomes
\[
o_{i,t}=o_{i,t-1}+\sum_{k:\,\mathrm{orders}_{i,k}=1}x_{t,k}.
\]
Because exactly one product is selected at each position, this sum equals the original variable-indexed lookup `orders[i,s[t]]`. This replaces the lookup and all-different structure with explicit linear assignment constraints suitable for HiGHS.

### Exact started and finished indicators

For each customer and prefix position, the model introduces binary indicators:

- \(A_{i,t}\): at least one requested product has been completed;
- \(F_{i,t}\): all requested products have been completed.

For customers with \(n_i>0\), the indicators are linked to the original cumulative counts by
\[
A_{i,t}\le o_{i,t}\le n_iA_{i,t},
\]
\[
n_iF_{i,t}\le o_{i,t}\le n_i-1+F_{i,t}.
\]

These inequalities are exact because the cumulative counts are integers between zero and \(n_i\). Thus, \(A_{i,t}=1\) precisely when \(o_{i,t}>0\), and \(F_{i,t}=1\) precisely when \(o_{i,t}=n_i\).

The open-stack count at step \(t\) is consequently
\[
\sum_{i:n_i>0}\left(A_{i,t}-F_{i,t-1}\right).
\]
A customer finished before the step must also have started by the step, so the difference is either zero or one and matches the original activity condition. The objective remains the **exact maximum** of these counts, preserving its meaning even when original variables are externally fixed.

### Temporal strengthening constraints

Let
\[
h_{i,t}=o_{i,t}-o_{i,t-1}.
\]
The assignment equations and binary order data imply \(h_{i,t}\in\{0,1\}\). The reformulation adds linear constraints expressing:

- a customer has started by step \(t\) exactly when it had already started or receives a requested product at that step;
- a customer is finished before step \(t\) exactly when it is finished after the step and receives no requested product at that step.

It also imposes
\[
A_{i,t}-F_{i,t-1}\ge h_{i,t}.
\]
This inequality is valid because receiving a requested product means the customer has started by that step and could not have finished beforehand. These constraints strengthen the linear relaxation without excluding any original feasible schedule.

### Endpoint deductions and zero-order preprocessing

The model explicitly imposes \(o_{i,p}=n_i\). This follows from the original permutation and cumulative updates: after every product has been produced once, every requested product has been completed.

For positive-order customers, the initial and final indicator values therefore follow directly. Customers with \(n_i=0\), identified from the input, have their started indicators fixed to zero and finished indicators fixed to one. They are excluded from the open-stack sum because the original condition \(o_{i,t-1}<0\) can never hold.

### Product-based lower bounds

For every product \(k\), the model adds
\[
\mathrm{objective}\ge\sum_i\mathrm{orders}_{i,k}.
\]

Every customer requesting product \(k\) is open when it is produced: that customer has started by the step and cannot have finished before receiving \(k\). Hence all customers ordering the same product contribute simultaneously, making this a valid problem-specific lower bound.

## Preservation and expected effect

The external data interface and the original variables `s`, `o`, and `objective` are retained. The mapping script copies those variables unchanged and omits reformulation-specific auxiliaries. No products or customers are merged, and no symmetry-breaking assumptions are introduced.

The reformulation trades additional binary variables for explicit linear structure and strengthening inequalities. It is intended to improve HiGHS performance, although no runtime improvement has been established by benchmarking in this conversation.
