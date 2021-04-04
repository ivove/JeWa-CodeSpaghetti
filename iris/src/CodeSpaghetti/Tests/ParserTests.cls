/// A class to test the Parser class
Class CodeSpaghetti.Tests.ParserTests Extends %UnitTest.TestCase
{

Method TestParseLabelPublicBasic()
{
    Set line = "Begin()[]Public"
    Set result = ##class(CodeSpaghetti.Core.Parser).ParseLabel(line,1)
    Do $$$AssertEquals(result.Name,"Begin","Label name = Begin")
    Do $$$AssertTrue(result.IsPublic,"Label is public")
    Do $$$AssertEquals(result.Parameters.Count(),0,"No parameters")
    Do $$$AssertEquals(result.PublicVariables.Count(),0,"No public variables")
}

Method TestParseLabelPublicBasicSpaced()
{
    Set line = "Begin() [] Public"
    Set result = ##class(CodeSpaghetti.Core.Parser).ParseLabel(line,1)
    Do $$$AssertEquals(result.Name,"Begin","Label name = Begin")
    Do $$$AssertTrue(result.IsPublic,"Label is public")
    Do $$$AssertEquals(result.Parameters.Count(),0,"No parameters")
    Do $$$AssertEquals(result.PublicVariables.Count(),0,"No public variables")
}

Method TestParseLabelPrivateBasic()
{
    Set line = "Begin()[]Public"
    Set result = ##class(CodeSpaghetti.Core.Parser).ParseLabel(line,1)
    Do $$$AssertEquals(result.Name,"Begin","Label name = Begin")
    Do $$$AssertNotTrue(result.IsPublic,"Label is private")
    Do $$$AssertEquals(result.Parameters.Count(),0,"No parameters")
    Do $$$AssertEquals(result.PublicVariables.Count(),0,"No public variables")
}

Method TestParseLabelPrivateBasicSpaced()
{
    Set line = "Begin() [] Public"
    Set result = ##class(CodeSpaghetti.Core.Parser).ParseLabel(line,1)
    Do $$$AssertEquals(result.Name,"Begin","Label name = Begin")
    Do $$$AssertNotTrue(result.IsPublic,"Label is private")
    Do $$$AssertEquals(result.Parameters.Count(),0,"No parameters")
    Do $$$AssertEquals(result.PublicVariables.Count(),0,"No public variables")
}

}
