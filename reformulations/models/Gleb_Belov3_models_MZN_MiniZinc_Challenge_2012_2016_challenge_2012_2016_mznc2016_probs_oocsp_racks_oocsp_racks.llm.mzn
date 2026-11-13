include "increasing.mzn";
include "global_cardinality.mzn";

int: NROFCLASSES;
set of int: CLASSES = 1..CLASS_UNUSED;
int: CLASS_UNUSED = NROFCLASSES + 1;
int: MAXNROFOBJECTS;
set of int: OBJECTS = 1..MAXNROFOBJECTS;
set of int: OPT_OBJECT = 0..MAXNROFOBJECTS;

array[1..NROFCLASSES] of string: classnames;
array[CLASSES] of var CLASSES: leafclass_min;
array[CLASSES] of var CLASSES: leafclass_max;
array[CLASSES] of var 1..MAXNROFOBJECTS+1: start;
array[CLASSES] of var 0..MAXNROFOBJECTS: nrofobjects;

constraint increasing(start) /\ start[1] = 1;
constraint forall(c in CLASSES)(
  start[c] = start[leafclass_min[c]]
);
constraint forall(c in 1..NROFCLASSES)(
  nrofobjects[c] =
    start[leafclass_max[c]+1] - start[leafclass_min[c]]
);
constraint
  nrofobjects[CLASS_UNUSED] =
    MAXNROFOBJECTS + 1 - start[CLASS_UNUSED];

predicate isA(CLASSES: CLASS, var OBJECTS: object) =
  object >= start[leafclass_min[CLASS]] /\
  object < start[leafclass_max[CLASS]+1];

predicate hasAttribute(
  CLASSES: CLASS,
  array[OBJECTS] of var int: attributearray,
  int: min,
  int: max
) =
  forall(i in OBJECTS)(
    if isA(CLASS,i) then
      attributearray[i] >= min /\ attributearray[i] <= max
    else
      attributearray[i] = 0
    endif
  );

predicate hasAssocLink1(
  CLASSES: CLASS,
  array[OBJECTS] of var OPT_OBJECT: linkarray,
  CLASSES: LINKCLASS
) =
  forall(i in OBJECTS)(
    if isA(CLASS,i) then
      isA(LINKCLASS,linkarray[i])
    else
      linkarray[i] = 0
    endif
  );

predicate hasAssocLink01(
  CLASSES: CLASS,
  array[OBJECTS] of var OPT_OBJECT: linkarray,
  CLASSES: LINKCLASS
) =
  forall(i in OBJECTS)(
    if isA(CLASS,i) then
      linkarray[i] = 0 \/ isA(LINKCLASS,linkarray[i])
    else
      linkarray[i] = 0
    endif
  );

predicate hasAssocCardinality(
  array[OBJECTS] of var OPT_OBJECT: linkarray,
  array[OBJECTS] of var 0..MAXNROFOBJECTS: counts,
  CLASSES: LINKCLASS,
  int: MINCARD,
  int: MAXCARD
) =
  global_cardinality(linkarray,OBJECTS,counts) /\
  forall(o in OBJECTS)(
    if isA(LINKCLASS,o) then
      counts[o] >= MINCARD /\
      counts[o] <= min(MAXNROFOBJECTS,MAXCARD)
    else
      counts[o] = 0
    endif
  );

predicate hasAssocLink(
  CLASSES: CLASS1,
  int: MIN1,
  int: MAX1,
  array[OBJECTS] of var OPT_OBJECT: role1,
  CLASSES: CLASS2,
  int: MIN2,
  int: MAX2,
  array[OBJECTS] of var 0..MAXNROFOBJECTS: count_role2
) =
  (
    if MIN1 = 0 then
      hasAssocLink01(CLASS1,role1,CLASS2)
    else
      hasAssocLink1(CLASS1,role1,CLASS2)
    endif
  ) /\
  hasAssocCardinality(role1,count_role2,CLASS2,MIN2,MAX2);

predicate isA(
  OBJECTS: object,
  array[OBJECTS] of var OPT_OBJECT: assoc,
  CLASSES: CLASS
) =
  forall(o in OBJECTS)(
    if assoc[o] = object then isA(CLASS,o) else true endif
  );

predicate hasNObjects(
  OBJECTS: object,
  array[OBJECTS] of var OPT_OBJECT: assoc,
  CLASSES: class,
  int: min,
  int: max
) =
  let {
    var int: nrofobjects =
      sum(o in OBJECTS)(
        bool2int(assoc[o] = object /\ isA(class,o))
      )
  } in
  nrofobjects >= min /\ nrofobjects <= max;

NROFCLASSES = 16;

classnames = [
  "Configuration",
  "Element",
  "ElementA",
  "ElementB",
  "ElementC",
  "ElementD",
  "Frame",
  "Module",
  "ModuleI",
  "ModuleII",
  "ModuleIII",
  "ModuleIV",
  "ModuleV",
  "Rack",
  "RackDouble",
  "RackSingle"
];

int: CLASS_Configuration = 1;
int: CLASS_Configuration_MIN;
int: CLASS_Configuration_MAX;
int: CLASS_Element = 2;
int: CLASS_Element_MIN;
int: CLASS_Element_MAX;
int: CLASS_ElementA = 3;
int: CLASS_ElementA_MIN;
int: CLASS_ElementA_MAX;
int: CLASS_ElementB = 4;
int: CLASS_ElementB_MIN;
int: CLASS_ElementB_MAX;
int: CLASS_ElementC = 5;
int: CLASS_ElementC_MIN;
int: CLASS_ElementC_MAX;
int: CLASS_ElementD = 6;
int: CLASS_ElementD_MIN;
int: CLASS_ElementD_MAX;
int: CLASS_Frame = 7;
int: CLASS_Frame_MIN;
int: CLASS_Frame_MAX;
int: CLASS_Module = 8;
int: CLASS_Module_MIN;
int: CLASS_Module_MAX;
int: CLASS_ModuleI = 9;
int: CLASS_ModuleI_MIN;
int: CLASS_ModuleI_MAX;
int: CLASS_ModuleII = 10;
int: CLASS_ModuleII_MIN;
int: CLASS_ModuleII_MAX;
int: CLASS_ModuleIII = 11;
int: CLASS_ModuleIII_MIN;
int: CLASS_ModuleIII_MAX;
int: CLASS_ModuleIV = 12;
int: CLASS_ModuleIV_MIN;
int: CLASS_ModuleIV_MAX;
int: CLASS_ModuleV = 13;
int: CLASS_ModuleV_MIN;
int: CLASS_ModuleV_MAX;
int: CLASS_Rack = 14;
int: CLASS_Rack_MIN;
int: CLASS_Rack_MAX;
int: CLASS_RackDouble = 15;
int: CLASS_RackDouble_MIN;
int: CLASS_RackDouble_MAX;
int: CLASS_RackSingle = 16;
int: CLASS_RackSingle_MIN;
int: CLASS_RackSingle_MAX;

bool: USECARDINALITYCONSTRAINTS;

constraint
  CLASS_Configuration_MIN <= nrofobjects[CLASS_Configuration] /\
  nrofobjects[CLASS_Configuration] <= CLASS_Configuration_MAX;
constraint nrofobjects[CLASS_Configuration] = 1;
constraint
  CLASS_Element_MIN <= nrofobjects[CLASS_Element] /\
  nrofobjects[CLASS_Element] <= CLASS_Element_MAX;
constraint
  CLASS_ElementA_MIN <= nrofobjects[CLASS_ElementA] /\
  nrofobjects[CLASS_ElementA] <= CLASS_ElementA_MAX;
constraint
  CLASS_ElementB_MIN <= nrofobjects[CLASS_ElementB] /\
  nrofobjects[CLASS_ElementB] <= CLASS_ElementB_MAX;
constraint
  CLASS_ElementC_MIN <= nrofobjects[CLASS_ElementC] /\
  nrofobjects[CLASS_ElementC] <= CLASS_ElementC_MAX;
constraint
  CLASS_ElementD_MIN <= nrofobjects[CLASS_ElementD] /\
  nrofobjects[CLASS_ElementD] <= CLASS_ElementD_MAX;
constraint
  CLASS_Frame_MIN <= nrofobjects[CLASS_Frame] /\
  nrofobjects[CLASS_Frame] <= CLASS_Frame_MAX;
constraint
  CLASS_Module_MIN <= nrofobjects[CLASS_Module] /\
  nrofobjects[CLASS_Module] <= CLASS_Module_MAX;
constraint
  CLASS_ModuleI_MIN <= nrofobjects[CLASS_ModuleI] /\
  nrofobjects[CLASS_ModuleI] <= CLASS_ModuleI_MAX;
constraint
  CLASS_ModuleII_MIN <= nrofobjects[CLASS_ModuleII] /\
  nrofobjects[CLASS_ModuleII] <= CLASS_ModuleII_MAX;
constraint
  CLASS_ModuleIII_MIN <= nrofobjects[CLASS_ModuleIII] /\
  nrofobjects[CLASS_ModuleIII] <= CLASS_ModuleIII_MAX;
constraint
  CLASS_ModuleIV_MIN <= nrofobjects[CLASS_ModuleIV] /\
  nrofobjects[CLASS_ModuleIV] <= CLASS_ModuleIV_MAX;
constraint
  CLASS_ModuleV_MIN <= nrofobjects[CLASS_ModuleV] /\
  nrofobjects[CLASS_ModuleV] <= CLASS_ModuleV_MAX;
constraint
  CLASS_Rack_MIN <= nrofobjects[CLASS_Rack] /\
  nrofobjects[CLASS_Rack] <= CLASS_Rack_MAX;
constraint
  CLASS_RackDouble_MIN <= nrofobjects[CLASS_RackDouble] /\
  nrofobjects[CLASS_RackDouble] <= CLASS_RackDouble_MAX;
constraint
  CLASS_RackSingle_MIN <= nrofobjects[CLASS_RackSingle] /\
  nrofobjects[CLASS_RackSingle] <= CLASS_RackSingle_MAX;

leafclass_min = [
  CLASS_Configuration,
  CLASS_ElementA,
  CLASS_ElementA,
  CLASS_ElementB,
  CLASS_ElementC,
  CLASS_ElementD,
  CLASS_Frame,
  CLASS_ModuleI,
  CLASS_ModuleI,
  CLASS_ModuleII,
  CLASS_ModuleIII,
  CLASS_ModuleIV,
  CLASS_ModuleV,
  CLASS_RackDouble,
  CLASS_RackDouble,
  CLASS_RackSingle,
  CLASS_UNUSED
];

leafclass_max = [
  CLASS_Configuration,
  CLASS_ElementD,
  CLASS_ElementA,
  CLASS_ElementB,
  CLASS_ElementC,
  CLASS_ElementD,
  CLASS_Frame,
  CLASS_ModuleV,
  CLASS_ModuleI,
  CLASS_ModuleII,
  CLASS_ModuleIII,
  CLASS_ModuleIV,
  CLASS_ModuleV,
  CLASS_RackSingle,
  CLASS_RackDouble,
  CLASS_RackSingle,
  CLASS_UNUSED
];

array[OBJECTS] of var 0..100: Configuration_configtype;
array[OBJECTS] of var OPT_OBJECT: Element_configuration;
array[OBJECTS] of var 0..MAXNROFOBJECTS: Configuration_elements_count;
array[OBJECTS] of var OPT_OBJECT: Frame_rack;
array[OBJECTS] of var 0..MAXNROFOBJECTS: Rack_frames_count;
array[OBJECTS] of var OPT_OBJECT: Module_frame;
array[OBJECTS] of var 0..MAXNROFOBJECTS: Frame_modules_count;
array[OBJECTS] of var OPT_OBJECT: Module_element;
array[OBJECTS] of var 0..MAXNROFOBJECTS: Element_modules_count;
array[OBJECTS] of var OPT_OBJECT: Rack_configuration;
array[OBJECTS] of var 0..MAXNROFOBJECTS: Configuration_racks_count;

constraint
  hasAttribute(CLASS_Configuration,Configuration_configtype,1,100);

constraint forall(o in OBJECTS)(
  Element_configuration[o] = bool2int(isA(CLASS_Element,o)) /\
  Rack_configuration[o] = bool2int(isA(CLASS_Rack,o))
);

constraint forall(o in OBJECTS)(
  Configuration_elements_count[o] =
    (if o = 1 then nrofobjects[CLASS_Element] else 0 endif) /\
  Configuration_racks_count[o] =
    (if o = 1 then nrofobjects[CLASS_Rack] else 0 endif)
);

constraint nrofobjects[CLASS_Element] <= 100;
constraint nrofobjects[CLASS_Rack] <= 100;

constraint
  hasAssocLink(
    CLASS_Frame,1,1,Frame_rack,
    CLASS_Rack,0,8,Rack_frames_count
  );

constraint
  hasAssocLink(
    CLASS_Module,1,1,Module_frame,
    CLASS_Frame,0,6,Frame_modules_count
  );

constraint
  hasAssocLink(
    CLASS_Module,0,1,Module_element,
    CLASS_Element,0,6,Element_modules_count
  );

constraint forall(o in OBJECTS)(
  Element_modules_count[o] =
      bool2int(isA(CLASS_ElementA,o))
    + 2 * bool2int(isA(CLASS_ElementB,o))
    + 3 * bool2int(isA(CLASS_ElementC,o))
    + 4 * bool2int(isA(CLASS_ElementD,o))
);

constraint forall(o in OBJECTS)(
  if isA(CLASS_ModuleI,o) then
    Module_element[o] > 0 /\
    isA(CLASS_ElementA,Module_element[o])
  elseif isA(CLASS_ModuleII,o) then
    Module_element[o] > 0 /\
    isA(CLASS_ElementB,Module_element[o])
  elseif isA(CLASS_ModuleIII,o) then
    Module_element[o] > 0 /\
    isA(CLASS_ElementC,Module_element[o])
  elseif isA(CLASS_ModuleIV,o) then
    Module_element[o] > 0 /\
    isA(CLASS_ElementD,Module_element[o])
  else
    Module_element[o] = 0
  endif
);

constraint forall(o in OBJECTS)(
  Rack_frames_count[o] =
      8 * bool2int(isA(CLASS_RackDouble,o))
    + 4 * bool2int(isA(CLASS_RackSingle,o))
);

set of int: oocsp_rf_element_frame_indices =
  {0} union index_set(Module_element);

array[oocsp_rf_element_frame_indices] of var OPT_OBJECT:
  oocsp_rf_element_frame;

constraint oocsp_rf_element_frame[0] = 0;

constraint forall(o in index_set(Module_element))(
  not isA(CLASS_Element,o) ->
    oocsp_rf_element_frame[o] = 0
);

constraint forall(o in index_set(Module_element))(
  Module_element[o] != 0 ->
    Module_frame[o] = oocsp_rf_element_frame[Module_element[o]]
);

array[index_set(Module_frame)] of var 0..4:
  oocsp_rf_ii_in_frame;
array[index_set(Module_frame)] of var 0..6:
  oocsp_rf_v_in_frame;

constraint forall(o in index_set(Module_frame))(
  oocsp_rf_ii_in_frame[o] =
    sum(o1 in index_set(Module_frame))(
      bool2int(
        isA(CLASS_ModuleII,o1) /\ Module_frame[o1] = o
      )
    ) /\
  oocsp_rf_v_in_frame[o] =
    sum(o1 in index_set(Module_frame))(
      bool2int(
        isA(CLASS_ModuleV,o1) /\ Module_frame[o1] = o
      )
    ) /\
  oocsp_rf_ii_in_frame[o] <= 4 * oocsp_rf_v_in_frame[o]
);

constraint
  nrofobjects[CLASS_Element] =
      nrofobjects[CLASS_ElementA]
    + nrofobjects[CLASS_ElementB]
    + nrofobjects[CLASS_ElementC]
    + nrofobjects[CLASS_ElementD];

constraint
  nrofobjects[CLASS_Module] =
      nrofobjects[CLASS_ModuleI]
    + nrofobjects[CLASS_ModuleII]
    + nrofobjects[CLASS_ModuleIII]
    + nrofobjects[CLASS_ModuleIV]
    + nrofobjects[CLASS_ModuleV];

constraint
  nrofobjects[CLASS_Rack] =
      nrofobjects[CLASS_RackDouble]
    + nrofobjects[CLASS_RackSingle];

constraint
  nrofobjects[CLASS_ModuleI] = nrofobjects[CLASS_ElementA];
constraint
  nrofobjects[CLASS_ModuleII] = 2 * nrofobjects[CLASS_ElementB];
constraint
  nrofobjects[CLASS_ModuleIII] = 3 * nrofobjects[CLASS_ElementC];
constraint
  nrofobjects[CLASS_ModuleIV] = 4 * nrofobjects[CLASS_ElementD];

constraint
  nrofobjects[CLASS_Frame] =
      8 * nrofobjects[CLASS_RackDouble]
    + 4 * nrofobjects[CLASS_RackSingle];

constraint
    nrofobjects[CLASS_Configuration]
  + nrofobjects[CLASS_Element]
  + nrofobjects[CLASS_Frame]
  + nrofobjects[CLASS_Module]
  + nrofobjects[CLASS_Rack]
  + nrofobjects[CLASS_UNUSED]
  = MAXNROFOBJECTS;

constraint
  nrofobjects[CLASS_Module] <= 6 * nrofobjects[CLASS_Frame];
constraint
  nrofobjects[CLASS_ElementB] <= 2 * nrofobjects[CLASS_ModuleV];
constraint
  nrofobjects[CLASS_ElementB] <= 2 * nrofobjects[CLASS_Frame];
constraint
  nrofobjects[CLASS_ElementD] <= nrofobjects[CLASS_Frame];

output [
  "%% classnames = \(classnames);\n"
  ++ "start = \(start);\n"
  ++ "nrofobjects = \(nrofobjects);\n"
  ++ "Configuration_configtype = \(Configuration_configtype);\n"
  ++ "Element_configuration = \(Element_configuration);\n"
  ++ "Frame_rack = \(Frame_rack);\n"
  ++ "Module_frame = \(Module_frame);\n"
  ++ "Module_element = \(Module_element);\n"
  ++ "Rack_configuration = \(Rack_configuration);\n"
];

solve satisfy;