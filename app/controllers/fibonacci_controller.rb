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