/// Class representing one routine or one class
Class CodeSpaghetti.Data.CodeFile Extends %Persistent
{

/// The name of the codefile
Property Name As %String;

/// The namespace the fiole resides in
Property Namespace As %String;

/// The content of the codefile
Property Content As list Of CodeSpaghetti.Data.CodeChunk;

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

/// Get all codeFiles. The onlyUnparsed switch controlles if only unparsed files should be returned
ClassMethod GetAll(onlyUnparsed As %Boolean = 0) As %ListOfObjects
{
    Set list = ##class(%ListOfObjects).%New()
    Set sqlStatement = ##class(%SQL.Statement).%New()
    Set sqlStatus = sqlStatement.%PrepareClassQuery("CodeSpaghetti.Data.CodeFile","Extent")
    If sqlStatus '= 1 { Throw ##class(%Exception.General).%New("CodeSpaghetti Error","1002",,"Failed to prepare Codefile extent query") }
    Set resultset = sqlStatement.%Execute()
    While resultset.%Next() {
        Set file = ##class(CodeSpaghetti.Data.CodeFile).%OpenId(resultset.%GetData(1))
        If file '= $$$NULLOREF {
            Set add = 1 
            If onlyUnparsed,file.IsParsed { Set add = 0 }
            If add { Do list.Insert(file) }
        }
    }
    Return list
}

/// Returns wether or not this file has been parsed
Method IsParsed() As %Boolean
{
    Set parsed = 0
    If ..Content.Count() > 0 { Set parsed = 1 }
    Return parsed
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
<Data name="Content">
<Attribute>Content</Attribute>
<Structure>subnode</Structure>
<Subscript>"Content"</Subscript>
</Data>
<DataLocation>^CodeSpaghetti.Data.CodeFileD</DataLocation>
<DefaultData>CodeFileDefaultData</DefaultData>
<IdLocation>^CodeSpaghetti.Data.CodeFileD</IdLocation>
<IndexLocation>^CodeSpaghetti.Data.CodeFileI</IndexLocation>
<StreamLocation>^CodeSpaghetti.Data.CodeFileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
