/// Class to hold a chunk of code. 
Class CodeSpaghetti.Data.CodeChunk Extends %Persistent
{

/// The content
Property Content As %String;

/// Children of this chunk
Property Children As list Of CodeSpaghetti.Data.CodeChunk;

/// The linenumber for this chunk. This is the linenumber in the original routine
Property Position As %Integer;

Storage Default
{
<Data name="CodeChunkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Content</Value>
</Value>
<Value name="3">
<Value>Children</Value>
</Value>
<Value name="4">
<Value>Position</Value>
</Value>
</Data>
<DataLocation>^CodeSpaghetti.Data.CodeChunkD</DataLocation>
<DefaultData>CodeChunkDefaultData</DefaultData>
<IdLocation>^CodeSpaghetti.Data.CodeChunkD</IdLocation>
<IndexLocation>^CodeSpaghetti.Data.CodeChunkI</IndexLocation>
<StreamLocation>^CodeSpaghetti.Data.CodeChunkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
