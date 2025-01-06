require 'test_helper'

class FibonacciControllerTest < ActionDispatch::IntegrationTest
  test "should get fibonacci number" do
    get '/fib', params: { n: 10 }
    assert_response :success
    assert_equal({ "result" => 55 }, JSON.parse(response.body))
  end

  test "should return bad request for negative number n=-1" do
    get '/fib', params: { n: -1 }
    assert_response :bad_request
    assert_equal({ "status" => 400, "message" => "Bad request."}, JSON.parse(response.body))
  end

  test "should return bad request for negative number n=0" do
    get '/fib', params: { n: 0 }
    assert_response :bad_request
    assert_equal({ "status" => 400, "message" => "Bad request."}, JSON.parse(response.body))
  end

  test "should return bad request for negative number n=test" do
    get '/fib', params: { n: "test" }
    assert_response :bad_request
    assert_equal({ "status" => 400, "message" => "Bad request."}, JSON.parse(response.body))
  end
end