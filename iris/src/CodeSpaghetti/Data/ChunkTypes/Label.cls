/// Class to hold a label definition
Class CodeSpaghetti.Data.ChunkTypes.Label Extends CodeSpaghetti.Data.CodeChunk
{

/// Is this a public label
Property IsPublic As %Boolean;

/// The parameters for this label
Property Parameters As list Of %String;

/// The public variables for this label
Property PublicVaraibles As list Of %String;

Storage Default
{
<Data name="LabelDefaultData">
<Subscript>"Label"</Subscript>
<Value name="1">
<Value>IsPublic</Value>
</Value>
<Value name="2">
<Value>Parameters</Value>
</Value>
<Value name="3">
<Value>PublicVaraibles</Value>
</Value>
</Data>
<DefaultData>LabelDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
