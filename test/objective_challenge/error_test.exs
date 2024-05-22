defmodule ObjectiveChallenge.ErrorTest do
  use ObjectiveChallenge.DataCase, async: true

  alias ObjectiveChallenge.Error

  describe "build/2" do
    test "should build an error struct" do
      response = Error.build(:bad_request, "invalid param")
      assert %Error{status: :bad_request, result: "invalid param"} == response
    end
  end
end
