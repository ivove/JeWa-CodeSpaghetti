/// Class to keep track of a comment
Class CodeSpaghetti.Data.ChunkTypes.Comment Extends CodeSpaghetti.Data.CodeChunk
{

/// Is this a multiline comment
Property IsMultiline As %Boolean;

Storage Default
{
<Data name="CommentDefaultData">
<Subscript>"Comment"</Subscript>
<Value name="1">
<Value>IsMultiline</Value>
</Value>
</Data>
<DefaultData>CommentDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
