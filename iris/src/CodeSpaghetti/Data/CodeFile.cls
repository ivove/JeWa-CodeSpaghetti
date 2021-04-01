/// Class representing one routine or one class
Class CodeSpaghetti.Data.CodeFile Extends %Persistent
{

/// The name of the codefile
Property Name As %String;

/// The namespace the fiole resides in
Property Namespace As %String;

/// Creates and returns a new instance. If an instance already exists, it returns te existing instance
/// This does not save the newly created instance!!
ClassMethod CreateOrGet(name As %String, namespace As %String) As CodeSpaghetti.Data.CodeFile
{
    Set result = $$$NULLOREF
    Set result = ..Get(name,namespace)
    If result = $$$NULLOREF {
        Set result = ..%New()
        Set result.Name = name
        Set result.Namespace = namespace
    }
    Return result
}

/// Gets an instance by its name and namespace
ClassMethod Get(name As %String, namespace As %String) As CodeSpaghetti.Data.CodeFile
{
    Set result = $$$NULLOREF
    &SQL(SELECT id into :id FROM CodeSpaghetti_Data.CodeFile where name=:name and namespace=:namespace)
    If 'SQLCODE,id '= "" {
        Set result = ##class(CodeSpaghetti.Core.CodeFile).%OpenId(id)
    }
    Return result
}

Storage Default
{
<Data name="CodeFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Namespace</Value>
</Value>
</Data>
<DataLocation>^CodeSpaghetti.Data.CodeFileD</DataLocation>
<DefaultData>CodeFileDefaultData</DefaultData>
<IdLocation>^CodeSpaghetti.Data.CodeFileD</IdLocation>
<IndexLocation>^CodeSpaghetti.Data.CodeFileI</IndexLocation>
<StreamLocation>^CodeSpaghetti.Data.CodeFileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
