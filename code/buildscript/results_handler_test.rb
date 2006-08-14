require "jsunit_result_parser"
require "selenium_result_parser"
require "Hpricot"

class JsUnitResultParserTest < Test::Unit::TestCase
  def setup
    @parser = JsUnitResultParser.new
    request_body = "id=&userAgent=Mozilla%2F5.0+%28Windows%3B+U%3B+Windows+NT+5.1%3B+en-US%3B+rv%3A1.8.0.6%29+Gecko%2F20060728+Firefox%2F1.5.0.6&jsUnitVersion=2.2&time=9.704&url=http%3A%2F%2Flocalhost%3A8889%2Fjavascript%2Funittest%2Fbrowserbot%2Fsuite.html%3Ft%253D1155175664.828000&cacheBuster=1155175675875&testCases=http%3A%2F%2Flocalhost%3A8889%2Fjavascript%2Funittest%2Fbrowserbot%2Falert-handling-tests.html%3AtestShouldRemoveAlertWhenItIsRetreived%7C0%7CS%7C%7C&testCases=http%3A%2F%2Flocalhost%3A8889%2Fjavascript%2Funittest%2Fbrowserbot%2Falert-handling-tests.html%3AtestShouldReportMultipleAlertsInOrderIfGenerated%7C0%7CS%7C%7C&testCases=http%3A%2F%2Flocalhost%3A8889%2Fjavascript%2Funittest%2Fbrowserbot%2Falert-handling-tests.html%3AtestShouldReportSingleAlertIfGenerated%7C0%7CS%7C%7C"
    @req = RequestStub.new(request_body)
    @expected_result = ["http://localhost:8889/javascript/unittest/browserbot/alert-handling-tests.html:testShouldRemoveAlertWhenItIsRetreived|0|S||", "http://localhost:8889/javascript/unittest/browserbot/alert-handling-tests.html:testShouldReportMultipleAlertsInOrderIfGenerated|0|S||", "http://localhost:8889/javascript/unittest/browserbot/alert-handling-tests.html:testShouldReportSingleAlertIfGenerated|0|S||"]
  end
  
  def test_smoke
    puts CGI::unescape(@req.body)
    assert true
  end
  
  def test_should_parse_multiple_test_cases_from_request_body
    expected_result = ["http://localhost:8889/javascript/unittest/browserbot/alert-handling-tests.html:testShouldRemoveAlertWhenItIsRetreived|0|S||", "http://localhost:8889/javascript/unittest/browserbot/alert-handling-tests.html:testShouldReportMultipleAlertsInOrderIfGenerated|0|S||", "http://localhost:8889/javascript/unittest/browserbot/alert-handling-tests.html:testShouldReportSingleAlertIfGenerated|0|S||"]
    test_cases = @parser.parse(@req.body)
    assert_equal(3, test_cases.size)
    assert_equal(@expected_result, test_cases)
  end
  
  def test_should_generate_junit_report_from_request_body
    expected_result = ["http://localhost:8889/javascript/unittest/browserbot/alert-handling-tests.html:testShouldRemoveAlertWhenItIsRetreived|0|S||", "http://localhost:8889/javascript/unittest/browserbot/alert-handling-tests.html:testShouldReportMultipleAlertsInOrderIfGenerated|0|S||", "http://localhost:8889/javascript/unittest/browserbot/alert-handling-tests.html:testShouldReportSingleAlertIfGenerated|0|S||"]
    xml = @parser.to_xml(@req)
    @expected_result.each do |url|
      assert(xml.include?(url))
    end
  end
end

class SeleniumResultParserTest < Test::Unit::TestCase
  def setup
    @parser = SeleniumResultParser.new
    succ_request_body = "selenium.version=%40VERSION%40&selenium.revision=%40REVISION%40&result=passed&totalTime=2&numTestPasses=2&numTestFailures=0&numCommandPasses=1&numCommandFailures=0&numCommandErrors=0&testTable.1=%3Cdiv%3E%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E%0D%0A++++%3Ctr+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd+rowspan%3D%221%22+colspan%3D%223%22%3ETest+Form+Auto-completion+is+disabled%3Cbr%3E%0D%0A++++++%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++++%3Ctd%3Eopen%3C%2Ftd%3E%0D%0A++++++++%3Ctd%3E..%2Ftests%2Fhtml%2Ftest_type_page1.html%3C%2Ftd%3E%0D%0A++++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++++%3C%2Ftr%3E%0D%0A++++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++++%3Ctd%3Etype%3C%2Ftd%3E%0D%0A++++++++%3Ctd%3Eusername%3C%2Ftd%3E%0D%0A++++++++%3Ctd%3ETestUser%3C%2Ftd%3E%0D%0A++++++%3C%2Ftr%3E%0D%0A++++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++++%3Ctd%3Etype%3C%2Ftd%3E%0D%0A++++++++%3Ctd%3Epassword%3C%2Ftd%3E%0D%0A++++++++%3Ctd%3EtestUserPassword%3C%2Ftd%3E%0D%0A++++++%3C%2Ftr%3E%0D%0A++++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++++%3Ctd%3EclickAndWait%3C%2Ftd%3E%0D%0A++++++++%3Ctd%3EsubmitButton%3C%2Ftd%3E%0D%0A++++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++++%3C%2Ftr%3E%0D%0A++++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++++%3Ctd%3EverifyTextPresent%3C%2Ftd%3E%0D%0A++++++++%3Ctd%3EWelcome%2C+TestUser%21%3Cbr%3E%0D%0A++++++++%3C%2Ftd%3E%0D%0A++++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++++%3C%2Ftr%3E%0D%0A++%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0A%0D%0A%3C%2Fdiv%3E&testTable.2=%3Cdiv%3E%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E%0D%0A++++%3Ctr+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd+rowspan%3D%221%22+colspan%3D%223%22%3ETest+popup+Window%3Cbr%3E%0D%0A++++++%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eopen%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E..%2Ftests%2Fhtml%2Ftest_select_window.html%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eclick%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EpopupPage%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Epause%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E1000%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%0D%0A++++%3C%2Ftd%3E%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3EselectWindow%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EmyPopupWindow%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eclose%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0A%0D%0A%3C%2Fdiv%3E&numTestTotal=3&suite=%0D%0A%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++++++++%3Ctbody%3E%0D%0A++++++++++++%3Ctr%3E%3Ctd+bgcolor%3D%22%23ccffcc%22%3E%3Cb%3ETest+Suite%3C%2Fb%3E%3C%2Ftd%3E%3C%2Ftr%3E%0D%0A++++++++++++%3Ctr%3E%3Ctd+bgcolor%3D%22%23ccffcc%22%3E%3Ca+href%3D%22.%2FTestFormAutocomplete.html%22%3ETest+Form+Auto-complete%3C%2Fa%3E%3C%2Ftd%3E%3C%2Ftr%3E%0D%0A++++++++++++%3Ctr%3E%3Ctd+bgcolor%3D%22%23ccffcc%22%3E%3Ca+href%3D%22.%2FTestPopupWindow.html%22%3ETest+Popup+Window%3C%2Fa%3E%3C%2Ftd%3E%3C%2Ftr%3E%0D%0A++++++++%3C%2Ftbody%3E%0D%0A++++%3C%2Ftable%3E%0D%0A%0D%0A%0D%0A"
    failed_request_body = "selenium.version=%40VERSION%40&selenium.revision=%40REVISION%40&result=failed&totalTime=4&numTestPasses=3&numTestFailures=1&numCommandPasses=41&numCommandFailures=3&numCommandErrors=0&testTable.1=%3Cdiv%3E%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E%0D%0A++++%3Ctr+bgcolor%3D%22%23ffcccc%22%3E%0D%0A++++++%3Ctd+rowspan%3D%221%22+colspan%3D%223%22%3ETest+Open%3Cbr%3E%0D%0A++++++%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eopen%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E..%2Ftests%2Fhtml%2Ftest_open_nonexist.html%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+title%3D%22Actual+value+%27http%3A%2F%2Flocalhost%3A8889%2Fjavascript%2Ftests%2Fhtml%2Ftest_open_nonexist.html%27+did+not+match+%27*%2Ftests%2Fhtml%2Ftest_open.html%27%22+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ffcccc%22%3E%0D%0A++++++%3Ctd%3EverifyLocation%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E*%2Ftests%2Fhtml%2Ftest_open.html%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EActual+value+%27http%3A%2F%2Flocalhost%3A8889%2Fjavascript%2Ftests%2Fhtml%2Ftest_open_nonexist.html%27+did+not+match+%27*%2Ftests%2Fhtml%2Ftest_open.html%27%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3C%21--+Should+really+split+these+verifications+into+their+own+test+file.--%3E%0D%0A++++%3Ctr+title%3D%22Actual+value+%27http%3A%2F%2Flocalhost%3A8889%2Fjavascript%2Ftests%2Fhtml%2Ftest_open_nonexist.html%27+did+not+match+%27regexp%3A.*%2Ftests%2Fhtml%2F%5BTt%5Dest_open.html%27%22+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ffcccc%22%3E%0D%0A++++++%3Ctd%3EverifyLocation%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Eregexp%3A.*%2Ftests%2Fhtml%2F%5BTt%5Dest_open.html%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EActual+value+%27http%3A%2F%2Flocalhost%3A8889%2Fjavascript%2Ftests%2Fhtml%2Ftest_open_nonexist.html%27+did+not+match+%27regexp%3A.*%2Ftests%2Fhtml%2F%5BTt%5Dest_open.html%27%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyNotLocation%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E*%2Ffoo.html%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+title%3D%22false%22+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ffcccc%22%3E%0D%0A++++++%3Ctd%3EverifyTextPresent%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EThis+is+a+test+of+the+open+command.%3Cbr%3E%0D%0A++++++%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Efalse%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eopen%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E..%2Ftests%2Fhtml%2Ftest_page.slow.html%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyLocation%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E*%2Ftests%2Fhtml%2Ftest_page.slow.html%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyTitle%3C%2Ftd%3E%0D%0A++++++%3Ctd%3ESlow+Loading+Page%3Cbr%3E%0D%0A++++++%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0A%0D%0A%3C%2Fdiv%3E&testTable.2=%3Cdiv%3E%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E%0D%0A++++%3Ctr+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd+rowspan%3D%221%22+colspan%3D%223%22%3ETest+Click%3Cbr%3E%0D%0A++++++%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eopen%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E..%2Ftests%2Fhtml%2Ftest_click_page1.html%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%0D%0A++++%3C%21--+Click+a+regular+link+--%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyText%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Elink%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EClick+here+for+next+page%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3EclickAndWait%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Elink%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyTitle%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EClick+Page+Target%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3EclickAndWait%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EpreviousPage%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyTitle%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EClick+Page+1%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%0D%0A++++%3C%21--+Click+a+link+with+an+enclosed+image+--%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3EclickAndWait%3C%2Ftd%3E%0D%0A++++++%3Ctd%3ElinkWithEnclosedImage%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyTitle%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EClick+Page+Target%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3EclickAndWait%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EpreviousPage%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%0D%0A++++%3C%21--+Click+an+image+enclosed+by+a+link+--%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3EclickAndWait%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EenclosedImage%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyTitle%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EClick+Page+Target%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3EclickAndWait%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EpreviousPage%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%0D%0A++++%3C%21--+Click+a+link+with+an+href+anchor+target+within+this+page+--%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eclick%3C%2Ftd%3E%0D%0A++++++%3Ctd%3ElinkToAnchorOnThisPage%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyTitle%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EClick+Page+1%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%0D%0A++++%3C%21--+Click+a+link+where+onclick+returns+false+--%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eclick%3C%2Ftd%3E%0D%0A++++++%3Ctd%3ElinkWithOnclickReturnsFalse%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3C%21--+Need+a+pause+to+give+the+page+a+chance+to+reload+%28so+this+test+can+fail%29+--%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%3Ctd%3Epause%3C%2Ftd%3E%3Ctd%3E300%3C%2Ftd%3E%3Ctd%3E%3C%2Ftd%3E%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyTitle%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EClick+Page+1%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%0D%0A++++%3C%21--+TODO+Click+a+link+with+a+target+attribute+--%3E%0D%0A%0D%0A++%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0A%3C%2Fdiv%3E&testTable.3=%3Cdiv%3E%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E%0D%0A++++%3Ctr+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd+rowspan%3D%221%22+colspan%3D%223%22%3ETest+Type%3Cbr%3E%0D%0A++++++%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eopen%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E..%2Ftests%2Fhtml%2Ftest_type_page1.html%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyValue%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Eusername%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Etype%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Eusername%3C%2Ftd%3E%0D%0A++++++%3Ctd%3ETestUser%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyValue%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Eusername%3C%2Ftd%3E%0D%0A++++++%3Ctd%3ETestUser%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyValue%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Epassword%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Etype%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Epassword%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtestUserPassword%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyValue%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Epassword%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtestUserPassword%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3EclickAndWait%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EsubmitButton%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifyTextPresent%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EWelcome%2C+TestUser%21%3Cbr%3E%0D%0A++++++%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0A%3C%2Fdiv%3E&testTable.4=%3Cdiv%3E%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E%0D%0A++++%3Ctr+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd+rowspan%3D%221%22+colspan%3D%223%22%3ETest+Select%3Cbr%3E%0D%0A++++++%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eopen%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E..%2Ftests%2Fhtml%2Ftest_select.html%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EassertSomethingSelected%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%26nbsp%3B%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EassertSelected%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3ESecond+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0A%0D%0AIndex%0D%0A%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eselect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Eindex%3D4%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelectedLabel%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EFifth+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelected%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Eindex%3D4%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelectedLabel%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EFifth+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelectedLabels%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EFifth+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0ALabel%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E++++%0D%0A%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eselect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EThird+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelected%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EThird+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelected%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Elabel%3DThird+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelectedLabel%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EThird+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eselect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Elabel%3DFourth+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelectedLabel%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EFourth+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelected%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EFourth+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0AValue%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eselect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Evalue%3Doption6%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelectedLabel%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3ESixth+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelectedValue%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Eoption6%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelected%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Evalue%3Doption6%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eselect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Evalue%3D%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelectedLabel%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EEmpty+Value+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0A%0D%0AIDs%0D%0A%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eselect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Eid%3Do4%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelectedLabel%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EFourth+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelectedId%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3Eo4%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0A%0D%0ANo+text+%3D+Empty+label%0D%0A%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23eeffee%22%3E%0D%0A++++++%3Ctd%3Eselect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelectedLabel%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelectedLabels%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0ASelect+an+option+that+doesn%27t+exist%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E%0D%0A++++%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EassertErrorOnNext%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EOption+with+label+%27Not+an+option%27+not+found%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3Eselect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3ENot+an+option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0AMulti-select+commands+will+not+work%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E%0D%0A++++%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EassertErrorOnNext%3C%2Ftd%3E%0D%0A++++++%3Ctd%3ENot+a+multi-select%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EaddSelection%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EFourth+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EassertErrorOnNext%3C%2Ftd%3E%0D%0A++++++%3Ctd%3ENot+a+multi-select%3C%2Ftd%3E%0D%0A++++++%3Ctd%3E%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EremoveSelection%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EFourth+Option%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0AassertSelectOptions%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++%3Ctbody%3E%0D%0A++++%0D%0A++++%3Ctr+style%3D%22cursor%3A+pointer%3B%22+bgcolor%3D%22%23ccffcc%22%3E%0D%0A++++++%3Ctd%3EverifySelectOptions%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EtheSelect%3C%2Ftd%3E%0D%0A++++++%3Ctd%3EFirst+Option%2CSecond+Option%2CThird+Option%2CFourth+Option%2CFifth+Option%2CSixth+Option%2CEmpty+Value+Option%2C%3C%2Ftd%3E%0D%0A++++%3C%2Ftr%3E%0D%0A++%3C%2Ftbody%3E%0D%0A%3C%2Ftable%3E%0D%0A%3C%2Fdiv%3E&numTestTotal=5&suite=%0D%0A%0D%0A%3Ctable+border%3D%221%22+cellpadding%3D%221%22+cellspacing%3D%221%22%3E%0D%0A++++++++%3Ctbody%3E%0D%0A++++++++++++%3Ctr%3E%3Ctd+bgcolor%3D%22%23ffcccc%22%3E%3Cb%3ETest+Suite%3C%2Fb%3E%3C%2Ftd%3E%3C%2Ftr%3E%0D%0A++++++++++++%3Ctr%3E%3Ctd+bgcolor%3D%22%23ffcccc%22%3E%3Ca+href%3D%22.%2FTestOpen.html%22%3ETestOpen%3C%2Fa%3E%3C%2Ftd%3E%3C%2Ftr%3E%0D%0A++++++++++++%3Ctr%3E%3Ctd+bgcolor%3D%22%23ccffcc%22%3E%3Ca+href%3D%22.%2FTestClick.html%22%3ETestClick%3C%2Fa%3E%3C%2Ftd%3E%3C%2Ftr%3E%0D%0A++++++++++++%3Ctr%3E%3Ctd+bgcolor%3D%22%23ccffcc%22%3E%3Ca+href%3D%22.%2FTestType.html%22%3ETestType%3C%2Fa%3E%3C%2Ftd%3E%3C%2Ftr%3E%0D%0A++++++++++++%3Ctr%3E%3Ctd+bgcolor%3D%22%23ccffcc%22%3E%3Ca+href%3D%22.%2FTestSelect.html%22%3ETestSelect%3C%2Fa%3E%3C%2Ftd%3E%3C%2Ftr%3E%0D%0A++++++++%3C%2Ftbody%3E%0D%0A++++%3C%2Ftable%3E%0D%0A%0D%0A"

    @succ_result_req = RequestStub.new(succ_request_body)
    @failed_result_req = RequestStub.new(failed_request_body)
  end
  
  def test_smoke
    assert_equal("passed", @succ_result_req.query["result"])
    assert_equal("@VERSION@", @succ_result_req.query["selenium.version"])
  end
  
  def test_should_generate_positive_junit_report_from_request_when_all_test_pass
    xml = @parser.to_xml(@succ_result_req)
    assert(xml.include?("TestFormAutocomplete"))
    assert(xml.include?('tests="2"'))
    assert(xml.include?('time="2"'))
    assert(xml.include?('failures="0"'))
    assert(xml.include?('errors="0"'))
  end
  
  def test_should_generate_negtive_junit_report_from_request_when_haveing_tests_failed
    error_message = "Actual value 'http://localhost:8889/javascript/tests/html/test_open_nonexist.html' did not match '*/tests/html/test_open.html'"
    xml = @parser.to_xml(@failed_result_req)
    assert(xml.include?("TestOpen"))
    assert(xml.include?('tests="4"'))
    assert(xml.include?('time="4"'))
    assert(xml.include?('failures="1"'))
    assert(xml.include?('errors="0"'))
    doc = Hpricot(xml)
    failures = doc.search("//testcase[@name='./TestOpen.html']/failure")
    assert_equal(1, failures.size)
    assert(failures[0].attributes["message"].include?(CGI::escape(error_message)))
  end
  
  
  def test_should_generate_result_table_from_request
    html = @parser.to_html(@succ_result_req)
    assert(html.include?("<table"))
    assert(html.include?("TestFormAutocomplete"))
  end
  
  def test_should_parse_test_cases_from_request
    expected_result = ["./TestFormAutocomplete.html", "./TestPopupWindow.html"]
    assert_equal(expected_result[0], @parser.parse(@succ_result_req)[0].testname)
    assert_equal(expected_result[1], @parser.parse(@succ_result_req)[1].testname)
  end
end

class RequestStub
  def initialize(request_body)
    @request_body = request_body
  end

  def body
    @request_body
  end

  def query 
    result = Hash.new
    @request_body.split("&").each do |pair|
      aPair = pair.split("=")
      result.store(aPair[0], CGI.unescape(aPair[1]))
    end
    return result
  end
end

class TestResultTest < Test::Unit::TestCase

  def test_xml_generation_for_succeed_test
    doc = Hpricot(TestResult.new("name", true).to_xml())
    assert_equal(1, doc.search("/testcase[@name=name]").size)    
  end
  
  def test_should_include_failure_tag_if_test_failed
    doc = Hpricot(TestResult.new("name", false, "error").to_xml())
    assert_equal(1, doc.search("/testcase/failure").size)
  end

end
