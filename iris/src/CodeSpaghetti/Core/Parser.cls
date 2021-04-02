/// Parser for routines and classes -> this will only parse discovered routines/classes
Class CodeSpaghetti.Core.Parser Extends %RegisteredObject
{

/// Parse one codefile
ClassMethod Parse(file As CodeSpaghetti.Data.CodeFile) As %Status
{
    Set sc = $$$OK
    Set ns = $ZNSPACE
    ZNspace file.Namespace
    #DIM routine as %Routine = ##class(%Routine).%OpenId(file.Name)
    If routine {
        Do routine.Rewind()
        While 'routine.AtEnd {
            Set line = routine.ReadLine()
            Write line,!
        }
    }
    Else {
        Throw ##class(%Exception.General).%New("CodeSpaghetti Error","3001",,"Routine "_file.Name_" in namespace "_file.Namespace_" does not exist")
    }
    ZNspace ns
    Return sc
}

/// Parse all codefiles in the given list
ClassMethod ParseList(list As %ListOfObjects) As %Status
{
    Set sc = $$$OK
    Set len = list.Count()
    For i=1:1:len {
        Set file = list.GetAt(i)
        If file '= $$$NULLOREF {
            Try {
                Do ..Parse(file)
            }
            Catch error {
                Set allErrors = $GET(allErrors) + 1
                Set allErrors(allErrors) = $SYSTEM.Status.Error(2001,"Failed to parse "_file.Name_" in namespace "_file.Namespace)
            }
        }
    }
    If (allErrors > 0) {
        For i=1:1:allErrors {
            Set sc = $SYSTEM.Status.AppendStatus(sc,allErrors(i))
        }
    }
    Return sc
}

/// Parse all unparsed codefiles
ClassMethod ParseAllUnparsed() As %Status
{
    Set sc = $$$OK
    Set list = ##class(CodeSpaghetti.Data.CodeFile).GetAll(1)
    Set sc = ..ParseList(list)
    Return sc
}

/// Parse all codeFiles
ClassMethod ParseAll() As %Status
{
    Set sc = $$$OK
    Set list = ##class(CodeSpaghetti.Data.CodeFile).GetAll()
    Set sc = ..ParseList(list)
    Return sc
}

}
