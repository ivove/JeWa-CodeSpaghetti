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

/// Pares one line
ClassMethod ParseLine(line As %String, lineNumber As %Integer) As %ListOfObjects
{
    Set result = ##class(%ListOfObjects).%New()
    Set testLine = $ZSTRIP(line,"<W") //strip whitespace in front of the first character
    If line = testLine {
        //this is a label

    }
    Return result
}

/// Parse the start of a Label
ClassMethod ParseLabel(line As %String, lineNumber As %Integer, ByRef explicitAccess As %Boolean = 0, ByRef labelStarted As %Boolean = 0, ByRef labelEnded As %Boolean = 0, parent As CodeSpaghetti.Data.CodeChunk = "") As CodeSpaghetti.Data.ChunkTypes.Label
{
    #DIM result as CodeSpaghetti.Data.ChunkTypes.Label = ##class(CodeSpaghetti.Data.ChunkTypes.Label).%New()
    Set result.Content = line
    Set result.Position = lineNumber
    Set result.Name = $PIECE($PIECE($PIECE($PIECE(line," "),"("),"["),"{")
    Set line = ..ParseParameters(line,.result)
    Set line = ..ParsePublicVariables(line,.result)
    If line '= "" {
        If $ZCONVERT(line,"U")?1"PUBLIC".E { 
            Set result.IsPublic = 1 
            Set line = $EXTRACT(line,$LENGTH("public"),*)
            Set explicitAccess = 1
        }
        ElseIf $ZCONVERT(line,"U")?1"PRIVATE".E { 
            Set result.IsPublic = 0 
            Set line = $EXTRACT(line,$LENGTH("private"),*)
            Set explicitAccess = 1
        }
    }
    If $ZSTRIP(line,"<W")?1"{".E { 
        Set line = $EXTRACT($ZSTRIP(line,"<W"),2,*) 
        If 'explicitAccess { 
            Set result.IsPublic = 0
            Set explicitAccess = 1
        }    
    } ElseIf $ZSTRIP(line,"<W")?.E {
        Set labelStarted = 1    
        If 'explicitAccess { 
            Set result.IsPublic = 1
            Set explicitAccess = 1
        }      
    }
    Return result
}

/// Parse the parameters of a label or a (class)method
ClassMethod ParseParameters(line As %String, ByRef chunk As CodeSpaghetti.Data.CodeChunk) As %String
{
    Set changedLine = $ZSTRIP($EXTRACT(line,$LENGTH(chunk.Name),*),"<W")
    If $EXTRACT(changedLine,1) = "(" {
        Set params = $PIECE($PIECE(changedLine,"(",2),")")
        If params '= "" {
            For i=1:1:$LENGTH(params,",") {
                Set par=$PIECE(params,",",i)
                Do chunk.Parameters.Insert(par)
            }
        }
        Set changedLine=$ZSTRIP($EXTRACT(changedLine,$LENGTH(params)+2,*),"<W")
    }
    Return changedLine
}

/// Parse the public variables for a label or a (class)method
ClassMethod ParsePublicVariables(line As %String, ByRef chunk As CodeSpaghetti.Data.CodeChunk) As %Status
{
    Set changedLine =line
    If $EXTRACT(changedLine,1) = "[" {
        Set publicVariables = $PIECE($PIECE(line,"[",2),"]")
        If (publicVariables '= ""){
            For i=1:1:$LENGTH(publicVariables,",") {
                Set var=$PIECE(publicVariables,",",i)
                Do chunk.PublicVariables.Insert(var)
            }
        }
        Set changedLine=$ZSTRIP($EXTRACT(line,$LENGTH(publicVariables)+2,*),"<W")
    }
    Return changedLine
}

/// Parse a comment
ClassMethod ParseComment(line As %String, lineNumber As %Integer, parent As CodeSpaghetti.Data.CodeChunk) As CodeSpaghetti.Data.ChunkTypes.Comment
{
    Set result = ##class(CodeSpaghetti.Data.ChunkTypes.Comment).%New()
    // do something
    Return result
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
