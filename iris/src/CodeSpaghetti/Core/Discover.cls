/// Core component to discover (new) routines and/or classes
Class CodeSpaghetti.Core.Discover Extends %RegisteredObject
{

/// Discover all routines in this namespace, or a subset using the filter parameter
ClassMethod DiscoverRoutines(filter As %String = "") As %Status
{
    If (filter = "") { Set filter = "*.MAC" }
    Set namespace = $ZNSPACE
    Set sqlStatement = ##class(%SQL.Statement).%New()
    Set sqlStatus = sqlStatement.%PrepareClassQuery("%Library.Routine","RoutineList")
    If sqlStatus '= 1 { Throw ##class(%Exception.General).%New("CodeSpaghetti Error","1001",,"Failed to prepare routinlist query") }
    Set resultset = sqlStatement.%Execute(filter,1,0)
    While resultset.%Next() {
        Set codeFile = ##class(CodeSpaghetti.Data.CodeFile).CreateOrGet(resultset.%GetData(1),namespace)
        Do codeFile.%Save(0)
    }
    Do resultset.%Close()
    Return $$$OK
}

}
