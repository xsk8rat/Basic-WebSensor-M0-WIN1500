(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Input::Initialization:: *)
Clear[GetAllValidSensorFileSuffix];
Options[GetAllValidSensorFileSuffix]={
};
GetAllValidSensorFileSuffix[OptionsPattern[]]:=Module[{},
{}=OptionValue[{}];
{"000","001","002","004","005","006","007","008","009"}
];
(*
GetAllValidSensorFileSuffix[]
*)


(* ::Input::Initialization:: *)
Clear[SensorFileExistsQ];
Options[SensorFileExistsQ]={
inWebServerOpt->"http://raspberrypi/"
};
SensorFileExistsQ[inFN_String
,OptionsPattern[]]:=Module[{
inWebServer
,useFN,useData
},
{inWebServer
}=OptionValue[{inWebServerOpt
}];
useFN=inWebServer<>inFN;
useData=Import[useFN];
If[StringMatchQ[useData,"*404 Not Found*",IgnoreCase->True]
,False
,True
]
];
(*testFN="Data_001_SensorJSON_2024-05.txt";
SensorFileExistsQ[testFN]
*)


(* ::Input::Initialization:: *)
Clear[GetMostRecentSensorFileName];
Options[GetMostRecentSensorFileName]={
inWebServerOpt->"http://raspberrypi/"
,inFileNameBaseOpt->"Data_USESUFFIX_SensorJSON_"<>"YEAR"<>"-"<>"MONTH"<>".txt"
,inMaxTriesOpt->10
};
GetMostRecentSensorFileName[inFN_String,OptionsPattern[]]:=Module[{
inWebServer,inFileNameBase,inMaxTries
,useFN,useDate
,iTry=0
},
{inWebServer,inFileNameBase,inMaxTries
}=OptionValue[{
inWebServerOpt,inFileNameBaseOpt,inMaxTriesOpt
}];
useDate=DateString[{"Year","-","Month"}];

While[!SensorFileExistsQ[useFN=StringReplace[inFileNameBase
,{"USESUFFIX"->inFN
,"YEAR-MONTH"->useDate
}]
,inWebServerOpt->inWebServer
]&&iTry<inMaxTries,
iTry++;
If[iTry==inMaxTries,
Print["Error in GetMostRecentSensorFileName: Unable to find datafile for"
,"\ninFN                         = ",inFN
,"\nIn less than inMaxTriesOpt -> ",inMaxTries
,"\nLast file name was ",useFN
];
Return[""];
];
useDate=DateString[
DatePlus[DateList[useDate],Quantity[-1,"month"]]
,{"Year","-","Month"}];
];
useFN
];
(*
GetMostRecentSensorFileName["000"]
*)


(* ::Input::Initialization:: *)
Clear[GetSensorNameOfTypeBySuffix];
Options[GetSensorNameOfTypeBySuffix]={
inWebServerOpt->"http://raspberrypi/"
};

GetSensorNameOfTypeBySuffix[inFN_String,inType_String,OptionsPattern[]]:=Module[{
inWebServer
,useType
,useFN,useData
},
{inWebServer
}=OptionValue[{inWebServerOpt
}];
useType=If[!StringMatchQ[inType,"UV*",IgnoreCase->True]
,inType
,"UVA"
];
useFN=GetMostRecentSensorFileName[inFN,inWebServerOpt->inWebServer];
useData=ImportWebDataDataset[useFN];
useData=Last[useData];
useData=Normal[useData[[useType<>"sensor"]]];
If[MissingQ[useData]||FailureQ[useData],
Return[""];
];
useData=StringReplace[useData,{
"Adafruit"->""
,"Sparkfun"->""
}
,IgnoreCase->True];
Capitalize[
useData
]
];
Attributes[GetSensorNameOfTypeBySuffix]={Listable};
(*
GetSensorNameOfTypeBySuffix["006","UVIndex"]
*)


(* ::Input::Initialization:: *)
Clear[GetSensorUnitsOfTypeBySuffix];
Options[GetSensorUnitsOfTypeBySuffix]={
inWebServerOpt->"http://raspberrypi/"
};

GetSensorUnitsOfTypeBySuffix[inFN_String,inType_String,OptionsPattern[]]:=Module[{
inWebServer
,useFN,useData,useUnit
},
{inWebServer
}=OptionValue[{inWebServerOpt
}];
useFN=GetMostRecentSensorFileName[inFN,inWebServerOpt->inWebServer];
useData=ImportWebDataDataset[useFN];
useData=Last[useData];
useUnit=Normal[useData[[inType<>"units"]]];
If[MissingQ[useUnit],
Return[""];
];
useUnit=Capitalize[useUnit];
If[StringMatchQ[useUnit,"F"]||StringMatchQ[useUnit,"C"]
,"\[Degree]"<>useUnit
,useUnit
]
];
Attributes[GetSensorUnitsOfTypeBySuffix]={Listable};
(*
GetSensorUnitsOfTypeBySuffix["000","temperature"]
*)


(* ::Input::Initialization:: *)
Clear[GetLocationBySuffix];
Options[GetLocationBySuffix]={
inWebServerOpt->"http://raspberrypi/"
};

GetLocationBySuffix[inFN_String,OptionsPattern[]]:=Module[{
inWebServer
,useFN,useData
},
{inWebServer
}=OptionValue[{inWebServerOpt
}];
useFN=GetMostRecentSensorFileName[inFN,inWebServerOpt->inWebServer];
useData=ImportWebDataDataset[useFN];
Capitalize[
Normal[Last[useData][["location"]]]
]
];
Attributes[GetLocationBySuffix]={Listable};
(*
GetLocationBySuffix[{"000","001"}]
*)


(* ::Input::Initialization:: *)
Clear[GetDeviceNameBySuffix];
Options[GetDeviceNameBySuffix]={
inWebServerOpt->"http://raspberrypi/"
};

GetDeviceNameBySuffix[inFN_String,OptionsPattern[]]:=Module[{
inWebServer
,useFN,useData
},
{inWebServer
}=OptionValue[{inWebServerOpt
}];
useFN=GetMostRecentSensorFileName[inFN,inWebServerOpt->inWebServer];
useData=ImportWebDataDataset[useFN];
Capitalize[
Normal[Last[useData][["DEVNAME"]]]
]
];
Attributes[GetDeviceNameBySuffix]={Listable};
(*
GetDeviceNameBySuffix[{"000","001"}]
*)


(* ::Input::Initialization:: *)
Clear[GetAllSensorKeysByFileSuffix];
Options[GetAllSensorKeysByFileSuffix]={
inWebServerOpt->"http://raspberrypi/"
};
GetAllSensorKeysByFileSuffix[inFN_String,OptionsPattern[]]:=Module[{
inWebServer
,useFN
,useData,allKeys
},
{inWebServer
}=OptionValue[{inWebServerOpt
}];
useFN=GetMostRecentSensorFileName[inFN,inWebServerOpt->inWebServer];
If[useFN==="",
Return[{}];
];
useData=ImportWebDataDataset[useFN];
allKeys=Union[Normal[Keys[Last[useData]]]];
allKeys
];
Attributes[GetAllSensorKeysByFileSuffix]={Listable};
(*
GetAllSensorKeysByFileSuffix["003"]
*)


(* ::Input::Initialization:: *)
Clear[GetMeasurementTypeByFileSuffix];
Options[GetMeasurementTypeByFileSuffix]={
inWebServerOpt->"http://raspberrypi/"
};
GetMeasurementTypeByFileSuffix[inFN_String,OptionsPattern[]]:=Module[{
inWebServer
,allKeys,allQuantities
},
{inWebServer
}=OptionValue[{inWebServerOpt
}];
allKeys=GetAllSensorKeysByFileSuffix[inFN,inWebServerOpt->inWebServer];
(* Handle errors early and often.
 *)
If[allKeys==={},
Return[{}];
];
allQuantities=(Capitalize[StringReplace[#,{"value"->""}]]&)/@Select[allKeys,(StringMatchQ[#,"*value"]&)];
allQuantities=Union[(StringReplace[#,{
"Particle"~~NumberString->"Particle"
,"Pm"~~NumberString->"Pm"
}]&)/@allQuantities];
allQuantities=GatherBy[allQuantities,(StringMatchQ[#,NumberString]&)];
If[Length[allQuantities]>1
,Join[allQuantities[[2]]
,{
"\[Lambda]="<>StringReplace[ToString[allQuantities[[1]]],{" "->""}]<>"nm"
}
]
,allQuantities[[1]]
]
];
Attributes[GetMeasurementTypeByFileSuffix]={Listable};
(*
GetMeasurementTypeByFileSuffix["000"]
*)


(* ::Input::Initialization:: *)
Clear[GetSensorInformationByFileSuffix];
Options[GetSensorInformationByFileSuffix]={
inWebServerOpt->"http://raspberrypi/"
,inUsePrefixOpt->{"CODEDIR","CODENAME","DEVNAME","location","wifiIPNumber"}
};
GetSensorInformationByFileSuffix[inFN_String,OptionsPattern[]]:=Module[{
inWebServer,inUsePrefix
,useFN,useData,allKeys,allQuantities
,outSensor,outIP
},
{inWebServer,inUsePrefix
}=OptionValue[{inWebServerOpt,inUsePrefixOpt
}];

useFN=GetMostRecentSensorFileName[inFN,inWebServerOpt->inWebServer];
useData=ImportWebDataDataset[useFN];
allKeys=Union[Normal[Keys[Last[useData]]]];
allQuantities=(Capitalize[StringReplace[#,{"value"->""}]]&)/@Select[allKeys,(StringMatchQ[#,"*value"]&)];
allKeys=Select[Union[Join[Select[allKeys,(StringMatchQ[#,"*sensor"]&)]
,inUsePrefix]]
,(!StringMatchQ[#,"wifipowersensor"]&)];
outSensor=Union[Normal[Values[Last[useData][Select[allKeys,(StringMatchQ[#,"*sensor"]&)]]]]];
outSensor=Select[outSensor,(!StringMatchQ[#,"None"]&)];

outSensor=(StringReplace[#,{"Adafruit_"->"","Sparkfun"->""},IgnoreCase->True]&)/@outSensor;
outIP=Last[useData]["wifiIPNumber"];
outIP=If[FailureQ[outIP]
,"No IP Provided"
,outIP
];
(*Print[Grid[{{
useFN
,outIP
,Last[useData]["location"]
,Grid[({#}&)/@Normal[Values[
Last[useData][{"CODENAME","CODEDIR","DEVNAME"}]
]]]
,Grid[({#}&)/@outSensor]
}}
,Frame->All,Alignment->Top
]];*)
{
useFN
,outIP
,Last[useData]["location"]
,TableForm[({#}&)/@Normal[Values[
Last[useData][{"CODENAME","CODEDIR","DEVNAME"}]
]]]
,TableForm[({#}&)/@outSensor]
,TableForm[GetMeasurementTypeByFileSuffix[inFN]]
}
];
Attributes[
GetSensorInformationByFileSuffix
]={Listable};
(*
GetSensorInformationByFileSuffix["000"]
*)


(* ::Input::Initialization:: *)
Clear[GetDataOfTypeFromFileBySuffix];
Options[GetDataOfTypeFromFileBySuffix]={
inWebServerOpt->"http://raspberrypi/"
,inShowErrorMessagesOpt->False
,inHowFarBackOpt->Infinity
};
GetDataOfTypeFromFileBySuffix[inFN_String,inDataType_String,OptionsPattern[]]:=Module[{
inWebServer,inShowErrorMessages,inHowFarBack
,useFN,allKeys,useData,allData
},
{inWebServer,inShowErrorMessages,inHowFarBack
}=OptionValue[{inWebServerOpt,inShowErrorMessagesOpt,inHowFarBackOpt
}];
useFN=GetMostRecentSensorFileName[inFN,inWebServerOpt->inWebServer];
If[useFN==="",
If[inShowErrorMessages,Print["Error in GetDataOfTypeFromFileBySuffix: No file found for suffix: ",inFN];];
Return[{}];
];
allKeys=GetAllSensorKeysByFileSuffix[inFN,inWebServerOpt->inWebServer];
(* Handle errors early and often.
 *)
If[allKeys==={},
If[inShowErrorMessages,Print["Error in GetDataOfTypeFromFileBySuffix: No measurement of keys found for suffix: ",inFN];];
Return[{}];
];
allKeys=Select[allKeys,(StringMatchQ[#,inDataType<>"*value",IgnoreCase->True]&)];
If[allKeys==={},
If[inShowErrorMessages,Print["Error in GetDataOfTypeFromFileBySuffix: No measurements found of type requested "
,"\nType   : ",inDataType
,"\nIn file: ",useFN
];
];
Return[{}];
];
allData=ImportWebDataDataset[useFN
,inHowFarBackOpt->inHowFarBack
];
useData=(allData[All,{"sampletime",#}]&)/@allKeys;
Normal[(Values[#]&)/@useData]
];
Attributes[
GetDataOfTypeFromFileBySuffix
]={Listable};
(*
testData=GetDataOfTypeFromFileBySuffix["000","temperature"];
DateListPlot[testData]
*)


(* ::Input::Initialization:: *)
Clear[MakeAllPlotsOfMeasurementType];
Options[MakeAllPlotsOfMeasurementType]={
inWebServerOpt->"http://raspberrypi/"
,inAllSuffixListOpt->GetAllValidSensorFileSuffix[]
,inFNTransformRulesOpt->{"_SensorJSON_"->" ...  "
,".txt"->""
}
,inHowFarBackOpt->Infinity
};
MakeAllPlotsOfMeasurementType[inMeasType_String,OptionsPattern[]]:=Module[{
inWebServer,inAllSuffixList,inFNTransformRules,inHowFarBack
,allSuffix,allData
,allFN,useSensor
,allLegendText
},
{inWebServer,inAllSuffixList,inFNTransformRules,inHowFarBack
}=OptionValue[{inWebServerOpt,inAllSuffixListOpt,inFNTransformRulesOpt,inHowFarBackOpt
}];
allSuffix=inAllSuffixList;
allData=(GetDataOfTypeFromFileBySuffix[#,inMeasType
,inHowFarBackOpt->inHowFarBack
]&)/@allSuffix;
(*allData=Select[allData,(Not[#==={}]&)];
*)(**)
allLegendText=(Grid[{{
GetLocationBySuffix[#],GetDeviceNameBySuffix[#]
},{
GetSensorNameOfTypeBySuffix[#,inMeasType]
,StringReplace[GetMostRecentSensorFileName[#,inWebServerOpt->inWebServer],inFNTransformRules]
}}]&)/@allSuffix;
(* Select data and legend text by non-empty data sets*)
{allData,allLegendText}=Transpose[
Select[Transpose[{allData,allLegendText}]
,(Not[#[[1]]==={}]&)]
];
(* Make the plot please. *)
DateListPlot[allData
,PlotLegends->Placed[allLegendText,Right]
,PlotLabel->Grid[{{Style[Capitalize[inMeasType],Bold,Black]
}
,{ToString[allSuffix]}
}]
,FrameStyle->Black,PlotRange->All,AspectRatio->1/2,ImageSize->600
,FrameLabel->{"Time and Date"
,Capitalize[inMeasType]<>" ("<>GetSensorUnitsOfTypeBySuffix[allSuffix[[1]],inMeasType]<>")"
}
]
];
Attributes[
MakeAllPlotsOfMeasurementType
]={Listable};
(*
MakeAllPlotsOfMeasurementType["temperature"
,inAllSuffixListOpt->GetAllValidSensorFileSuffix[][[1;;4]]
,inHowFarBackOpt->Quantity[1,"day"]
]
*)


(* ::Input::Initialization:: *)
Clear[GetSpectralDataFromSensor];
Options[GetSpectralDataFromSensor]={
inHttpAddressOpt->"http://10.132.245.110/"
};
GetSpectralDataFromSensor[OptionsPattern[]]:=Module[{
inHttpAddress
,tData
},
{inHttpAddress
}=OptionValue[{inHttpAddressOpt
}];
tData=Import[inHttpAddress];
tData=StringReplace[tData,{
"{"->""
,"}"->""
,":"->"->"
}];
tData=StringSplit[tData,{","}];
ToExpression[tData]
];
(*
GetSpectralDataFromSensor[]
*)


(* ::Input::Initialization:: *)
Clear[MakeAS7351SensorSpectrumPlot];
Options[MakeAS7351SensorSpectrumPlot]={
};
MakeAS7351SensorSpectrumPlot[inData_List,OptionsPattern[]]:=Module[{
allKeys,valueKeys,waveKeys,sensorKeys
,useData,useSensor
},
{
}=OptionValue[{
}];
allKeys=Keys[inData];
Print[allKeys];
valueKeys=Select[allKeys,(
StringMatchQ[#,NumberString~~"value"]||StringMatchQ[#,"UV*value"]||StringMatchQ[#,"NIR*value"]
&)];
waveKeys=Select[allKeys,(StringMatchQ[#,"*wavelength"]&)];
sensorKeys=Select[allKeys,(StringMatchQ[#,"*sensor"]&&Not[StringMatchQ[#,"wifi*"]]&)];
useData=({#[[2]]/.inData,#[[1]]/.inData,#[[3]]/.inData}&)/@Transpose[{valueKeys,waveKeys}];
useData=Sort[useData];

useSensor=useData[[All,3]];
Print[useSensor];
useSensor=Union[useSensor];
Print[useSensor];
(*useData=GatherBy[useData,(#[[3]]&)];*)
useData=useData[[All,All,1;;2]];

ListPlot[useData
,Joined->True,FrameStyle->Black
,FrameLabel->{"Wavelength (nm)","Intensity (arb.)"}
,PlotLabel->"Intensity by Wavelength (and sensor type)"
,PlotLegends->useSensor
]
];
(*
testData=GetSpectralDataFromSensor[];
MakeAS7351SensorSpectrumPlot[testData]
*)


(* ::Input::Initialization:: *)
Clear[ConvertWebDataToAssociation];
Options[ConvertWebDataToAssociation]={
inReturnbDatasetOpt->True
};
ConvertWebDataToAssociation[inData_String,OptionsPattern[]]:=Module[{
inReturnbDataset
,xList,xAssoc,outData
},
{inReturnbDataset
}=OptionValue[{inReturnbDatasetOpt
}];
(* Clean up the end of lines so the data is on one line only. *)
xList=StringSplit[
StringReplace[inData,{
"\n}\n"->"}\n","\n}"~~EndOfLine->"}\n"
}]
,"\n"];
xList=Select[xList,(!StringMatchQ[#,"*Error*"]&)];
xList=(ToExpression[StringReplace[#,{":"->"->"}]]&)/@xList;
xList=(Flatten[{
#[[1,1]]->StringReplace[#[[1,2]],{"->"->":"}]
,#[[2,2]]}]&)/@xList;
xList=If[inReturnbDataset
,Dataset[(Association[#]&)/@xList]
,xList
];
xList
];
(*
xData=Import["http://raspberrypi/Data_003_SensorJSON_2024-05.txt"];
testData=ConvertWebDataToAssociation[xData];

testData[[1]]
*)


(* ::Input::Initialization:: *)
Clear[ImportWebDataDataset];
Options[ImportWebDataDataset]={
inWebServerOpt->"http://raspberrypi/"
,inHowFarBackOpt->Infinity
};
ImportWebDataDataset[inFN_String,OptionsPattern[]]:=Module[{
inWebServer,inHowFarBack
,useFN,useData
,outData
},
{inWebServer,inHowFarBack
}=OptionValue[{inWebServerOpt,inHowFarBackOpt
}];
useFN=inWebServer<>inFN;
useData=Import[useFN];
outData=ConvertWebDataToAssociation[useData];
If[inHowFarBack===Infinity,Return[outData];];
outData=Select[outData,(DateDifference[#["sampletime"],Now]<inHowFarBack&)];
outData
];
(*
testFN="Data_001_SensorJSON_2024-05.txt";
testData=ImportWebDataDataset[testFN,inHowFarBackOpt->Quantity[1,"Day"]];
DateListPlot[testData[All,{"sampletime","wifipowervalue"}]
,FrameLabel->{"Date/Time","WiFi Power (dBmW)"}
]*)


(* ::Input::Initialization:: *)
Clear[MakeHTMLSensorReport];
Options[MakeHTMLSensorReport]={
inWebServerOpt->"http://raspberrypi/"
,inShowErrorMessagesOpt->False
,inHowFarBackOpt->Infinity
};
ModifyHTMLFile[inFN_String]:=Module[{
allText
},
allText=Import[inFN,"Source"];
allText=StringReplace[allText,{"Untitled"->"Sensor Report"}];
Export["~/dummy.txt",allText];
DeleteFile[inFN];
RenameFile["~/dummy.txt",inFN]
];
(*ModifyHTMLFile["/home/mark/SensorReport.html"]*)
MakeHTMLSensorReport[OptionsPattern[]]:=Module[{
inWebServer,inShowErrorMessages,inHowFarBack
,useImage,useFN
},
{inWebServer,inShowErrorMessages,inHowFarBack
}=OptionValue[{inWebServerOpt,inShowErrorMessagesOpt,inHowFarBackOpt
}];
useImage=Grid[Join[{{
DateString[]
}}
,({#}&)/@MakeAllPlotsOfMeasurementType[{"temperature","humidity"}
,inAllSuffixListOpt->{"000","001","002","004","007","008","009"}
,inHowFarBackOpt->Quantity[1,"day"]
]
,({#}&)/@MakeAllPlotsOfMeasurementType[{"temperature","humidity"}
,inAllSuffixListOpt->{"000","001","002","004","007","008","009"}
,inHowFarBackOpt->Quantity[7,"day"]
]
,({#}&)/@MakeAllPlotsOfMeasurementType[{"pressure"}
,inAllSuffixListOpt->{"003"}
,inHowFarBackOpt->Quantity[7,"day"]
]
,({#}&)/@MakeAllPlotsOfMeasurementType[{"carbondioxide"}
,inAllSuffixListOpt->{"004","007"}
,inHowFarBackOpt->Quantity[7,"day"]
]
,({#}&)/@MakeAllPlotsOfMeasurementType[{"wifipower"}
,inAllSuffixListOpt->GetAllValidSensorFileSuffix[]
,inHowFarBackOpt->Quantity[14,"day"]
]
,{{
Grid[Join[{(Style[#,Bold]&)/@{"Data File Name","IP Address","Location","Code Information","Sensors","Measurement Types"}}
,(GetSensorInformationByFileSuffix[#]&)/@GetAllValidSensorFileSuffix[]
],Frame->All,Alignment->Top
]
}}
]];
useFN="SensorReport.html";
Run["rm ~/"<>useFN];
Run["rm -r ~/HTMLFiles"];
Run["rm -r ~/HTMLLinks"];
Pause[2];
Export["/home/mark/"<>useFN
,useImage
,ImageSize->1500
,OverwriteTarget->True
,"HeadElements"->{"Title"->"Sensor Reports"}
];
ModifyHTMLFile[useFN];
Run["sudo rm /var/www/html/"<>useFN];
Run["sudo rm -r /var/www/html/HTMLFiles"];
Pause[1];
Run["sudo cp /home/mark/"<>useFN<>" /var/www/html/"<>useFN];
Run["sudo cp -r /home/mark/HTMLFiles /var/www/html/HTMLFiles"];
];
(*
MakeHTMLSensorReport[];
*)



