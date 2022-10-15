defmodule Lively.NodeTest do
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
                     details: "on paris_polygons_ar_08 as paris",
                     meta: [timing: 0.007, rows: 0, cost: 1.08],
                     type: "Seq Scan"
                   },
                   %Node{
                     children: [],
                     details: "on paris_points_ar_08 as paris",
                     meta: [timing: 0.085, rows: 4, cost: 5.16],
                     type: "Seq Scan"
                   },
                   %Node{
                     children: [],
                     details: "on paris_linestrings_ar_08 as paris",
                     meta: [timing: 0.103, rows: 0, cost: 7.27],
                     type: "Seq Scan"
                   },
                   %Node{
                     children: [],
                     details: "on paris_polygons as paris using idx_paris_polygons_tags",
                     meta: [timing: 0.002, rows: 0, cost: 8.27],
                     type: "Index Scan"
                   },
                   %Node{
                     children: [],
                     details: "on paris_points as paris using idx_paris_points_tags",
                     meta: [timing: 0.003, rows: 0, cost: 8.27],
                     type: "Index Scan"
                   },
                   %Node{
                     children: [],
                     details: "on paris_linestrings as paris",
                     meta: [timing: 0.001, rows: 0, cost: 11.8],
                     type: "Seq Scan"
                   },
                   %Node{
                     children: [],
                     details: "on paris as paris using idx_paris_tags",
                     meta: [timing: 0.009, rows: 0, cost: 8.27],
                     type: "Index Scan"
                   }
                 ],
                 details: nil,
                 meta: [timing: 0.218, rows: 4, cost: 50.11],
                 type: "Append"
               }
             ],
             details: nil,
             meta: [timing: 0.231, rows: 4, cost: 50.13],
             type: "Result"
           }
  end
end
