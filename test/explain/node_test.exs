defmodule Lively.Explain.NodeTest do
  use ExUnit.Case

  alias Lively.Explain.Node
  alias Lively.Test.Support.ExplainData

  test "build_tree" do
    plan = List.first(ExplainData.big_plan())["Plan"]

    assert Node.build_tree(plan) == %Node{
             children: [
               %Node{
                 children: [
                   %Node{
                     children: [],
                     meta: [{:timing, 0.007}, {:rows, 0}, {:cost, 1.08}],
                     type: "Seq Scan"
                   },
                   %Node{
                     children: [],
                     meta: [{:timing, 0.085}, {:rows, 4}, {:cost, 5.16}],
                     type: "Seq Scan"
                   },
                   %Node{
                     children: [],
                     meta: [{:timing, 0.103}, {:rows, 0}, {:cost, 7.27}],
                     type: "Seq Scan"
                   },
                   %Node{
                     children: [],
                     meta: [{:timing, 0.002}, {:rows, 0}, {:cost, 8.27}],
                     type: "Index Scan"
                   },
                   %Node{
                     children: [],
                     meta: [{:timing, 0.003}, {:rows, 0}, {:cost, 8.27}],
                     type: "Index Scan"
                   },
                   %Node{
                     children: [],
                     meta: [{:timing, 0.001}, {:rows, 0}, {:cost, 11.8}],
                     type: "Seq Scan"
                   },
                   %Node{
                     children: [],
                     meta: [{:timing, 0.009}, {:rows, 0}, {:cost, 8.27}],
                     type: "Index Scan"
                   }
                 ],
                 meta: [{:timing, 0.218}, {:rows, 4}, {:cost, 50.11}],
                 type: "Append"
               }
             ],
             meta: [{:timing, 0.231}, {:rows, 4}, {:cost, 50.13}],
             type: "Result"
           }
  end
end
