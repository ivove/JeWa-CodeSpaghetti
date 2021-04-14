/// A class to test the Parser class
Class CodeSpaghetti.Tests.ParserTests Extends %UnitTest.TestCase
{

Method TestParseLabelPublicBasic()
{
    Do ..LogMessage("Begin()[]Public")
    Set line = "Begin()[]Public"
    Set result = ##class(CodeSpaghetti.Core.Parser).ParseLabel(line,1)
    Do $$$AssertEquals(result.Name,"Begin","Label name = Begin")
    Do $$$AssertTrue(result.IsPublic,"Label is public")
    Do $$$AssertEquals(result.Parameters.Count(),0,"No parameters")
    Do $$$AssertEquals(result.PublicVariables.Count(),0,"No public variables")
}

Method TestParseLabelPublicBasicSpaced()
{
    Do ..LogMessage("Begin() [] Public")
    Set line = "Begin() [] Public"
    Set result = ##class(CodeSpaghetti.Core.Parser).ParseLabel(line,1)
    Do $$$AssertEquals(result.Name,"Begin","Label name = Begin")
    Do $$$AssertTrue(result.IsPublic,"Label is public")
    Do $$$AssertEquals(result.Parameters.Count(),0,"No parameters")
    Do $$$AssertEquals(result.PublicVariables.Count(),0,"No public variables")
}

Method TestParseLabelPrivateBasic()
{
    Do ..LogMessage("Begin()[]Private")
    Set line = "Begin()[]Private"
    Set result = ##class(CodeSpaghetti.Core.Parser).ParseLabel(line,1)
    Do $$$AssertEquals(result.Name,"Begin","Label name = Begin")
    Do $$$AssertNotTrue(result.IsPublic,"Label is private")
    Do $$$AssertEquals(result.Parameters.Count(),0,"No parameters")
    Do $$$AssertEquals(result.PublicVariables.Count(),0,"No public variables")
}

Method TestParseLabelPrivateBasicSpaced()
{
    Do ..LogMessage("Begin() [] private")
    Set line = "Begin() [] private"
    Set result = ##class(CodeSpaghetti.Core.Parser).ParseLabel(line,1)
    Do $$$AssertEquals(result.Name,"Begin","Label name = Begin")
    Do $$$AssertNotTrue(result.IsPublic,"Label is private")
    Do $$$AssertEquals(result.Parameters.Count(),0,"No parameters")
    Do $$$AssertEquals(result.PublicVariables.Count(),0,"No public variables")
}

Method TestParseBasicLabel()
{
    Do ..LogMessage("Begin() [] Public")
    Set line = "Begin() [] Public"
    Set result = ##class(CodeSpaghetti.Core.Parser).ParseLabel(line,1,.access,.started,.ended)
    Do $$$AssertTrue(access,"Access is explicitly defined")
    Do $$$AssertNotTrue(started,"Label is not yet started")
    Do $$$AssertNotTrue(ended,"Label has not yet ended")
    Do $$$AssertEquals(result.Name,"Begin","Label name = Begin")
    Do $$$AssertTrue(result.IsPublic,"Label is public")
    Do $$$AssertEquals(result.Parameters.Count(),0,"No parameters")
    Do $$$AssertEquals(result.PublicVariables.Count(),0,"No public variables")
}

Method TestParseWithParamAndPublicVar()
{
    Do ..LogMessage("next(testPar)[O]")
    Set line = "next(testPar)[O]"
    Set result = ##class(CodeSpaghetti.Core.Parser).ParseLabel(line,1,.access,.started,.ended)
    Do $$$AssertNotTrue(access,"Access is not explicitly defined")
    Do $$$AssertNotTrue(started,"Label is not yet started")
    Do $$$AssertNotTrue(ended,"Label has not yet ended")
    Do $$$AssertEquals(result.Name,"next","Label name = next")
    Do $$$AssertEquals(result.Parameters.Count(),1,"1 parameter")    
    Do $$$AssertEquals(result.Parameters.GetAt(1),"testPar","parameter = testPar")
    Do $$$AssertEquals(result.PublicVariables.Count(),1,"1 public variable")
    Do $$$AssertEquals(result.PublicVariables.GetAt(1),"O","O = public variable")
}

Method TestParseOneLiner()
{
    Do ..LogMessage("Funcky() { Write ""Oneliner"" }")
    Set line = "Funcky() { Write ""Oneliner"" }"
    Set result = ##class(CodeSpaghetti.Core.Parser).ParseLabel(line,1,.access,.started,.ended)
    Do $$$AssertTrue(access,"Access is not explicitly defined => oneliner")
    Do $$$AssertNotTrue(result.IsPublic,"Label is private => oneliner without acces-modifier")
    Do $$$AssertTrue(started,"Label is started => oneliner")
    Do $$$AssertTrue(ended,"Label has ended => oneliner")
    Do $$$AssertEquals(result.Name,"Funky","Label name = Funky")
    Do $$$AssertEquals(result.Parameters.Count(),0,"0 parameters")
}

Method TestParsePrivateOneLiner()
{
    Do ..LogMessage("Funcky()private { Write ""Oneliner"" }")
    Set line = "Funcky()private { Write ""Oneliner"" }"
    Set result = ##class(CodeSpaghetti.Core.Parser).ParseLabel(line,1,.access,.started,.ended)
    Do $$$AssertTrue(access,"Access is not explicitly defined => oneliner")
    Do $$$AssertNotTrue(result.IsPublic,"Label is private")
    Do $$$AssertTrue(started,"Label is started => oneliner")
    Do $$$AssertTrue(ended,"Label has ended => oneliner")
    Do $$$AssertEquals(result.Name,"Funky","Label name = Funky")
    Do $$$AssertEquals(result.Parameters.Count(),0,"0 parameters")
}

Method TestParsePublicOneLiner()
{
    Do ..LogMessage("Funcky()public { Write ""Oneliner"" }")
    Set line = "Funcky()public { Write ""Oneliner"" }"
    Set result = ##class(CodeSpaghetti.Core.Parser).ParseLabel(line,1,.access,.started,.ended)
    Do $$$AssertTrue(access,"Access is not explicitly defined => oneliner")
    Do $$$AssertTrue(result.IsPublic,"Label is public")
    Do $$$AssertTrue(started,"Label is started => oneliner")
    Do $$$AssertTrue(ended,"Label has ended => oneliner")
    Do $$$AssertEquals(result.Name,"Funky","Label name = Funky")
    Do $$$AssertEquals(result.Parameters.Count(),0,"0 parameters")
}

}
