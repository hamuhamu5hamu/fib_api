### このプログラムの概要
指定したn番目のフィボナッチ数を返すRuby on Railsを使ったREST APIです。
フィボナッチ数とは、一項目と2項目が1で、それ以降の項がすべて直前の二項の和になっている数列のことを指す。
不正な入力に対しては適切なエラーハンドリングを行い、エラーメッセージとHTTPステータスコードをJSON形式で返します。
このAPIは、APIモードで作成されたRailsアプリケーションで、リクエストを受けてフィボナッチ数を計算し、結果をJSON形式で返すシンプルな構成です。

### ファイルの説明
#### fibonacci_controller.rb
``` ruby
class FibonacciController < ApplicationController
  def show
    if params[:n].to_i.to_s == params[:n]
      n = params[:n].to_i
      # 入力値のバリデーション
      if n <= 0 then
        render json: { "status": 400, "message": "Bad request."}, status: :bad_request
        return
      end
        # フィボナッチ数の計算
        result = fibonacci(n)
        render json: { result: result }
        return
    else
      render json: { "status": 400, "message": "Bad request."}, status: :bad_request
      return
    end
  end

  private

  # フィボナッチ数を計算するメソッド
  def fibonacci(n)
    return n if n <= 1

    a, b = 0, 1
    (n - 1).times do
      a, b = b, a + b
    end
    b
  end
end
```

3行目の分岐文は、クエリパラメータは文字列で受け取られるため、パラメータの入力が期待しているもの(1以上の整数)であるかどうかを判断し、期待していないものであれば適切にエラーメッセージとHTTPステータスコード400を返している。これはAPIが不正なリクエストに対して、適切なレスポンスを返すことを保証します。期待したものであれば、フィボナッチ数と計算するメソッドを使用し、計算する。
メソッドでは、一行目に、"return n if n <= 1"という文があり、ここで、フィボナッチで計算するときの例外となる1の時に先に一ずつ数を増やしていってひとつ前の数と二つ前の数を足して今の数を出すのと同時に、数をずらすことで、フィボナッチ数を計算するようにしている。

#### routes.rb
``` ruby
Rails.application.routes.draw do
  get 'fib', to: 'fibonacci#show'
end
```

route.rbでは、fibというurlパスが来た際に、Fibonacci_controllerのshowアクションを動かすことを宣言している文になっている。

#### fibonacci_controller_test.rb
``` ruby
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
```

fibonacci_controller_test.rbでは、テストを作成する。
以下のテストでは、フィボナッチAPIの動作を確認する。
1つ目のテストでは、入力値が10の場合に、返されるフィボナッチ数が55であることを確認する。また、HTTPステータスコードが200で、レスポンスが成功しているかどうかも検証する。

2つ目のテストでは、入力値が負の数の場合に、適切なエラーメッセージが返されるかどうかを確認する。

3つ目のテストでは、入力値が0の場合に、適切なエラーメッセージが表示されることを確認する。

4つ目のテストでは、入力値が文字列（test）の場合に、適切なエラーメッセージが返されるかどうかを検証する。
