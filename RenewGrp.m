function RenewGrp(DataStruct, grpStr, LabelGrpName, LabelAnalytes)

LabelGrpName.Text = DataStruct.(grpStr).Name;
LabelAnalytes.Text = DataStruct.(grpStr).ListAnalyte;