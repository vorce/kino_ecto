defmodule KinoEcto.Explain.Postgres.NodeTest do
  use ExUnit.Case, async: true

  alias KinoEcto.Explain.Postgres.Node
  alias KinoEcto.Test.Support.ExplainData

  test "build_tree/1" do
    plan = List.first(ExplainData.big_plan())["Plan"]

    assert %Node{
             children: [
               %Node{
                 children: [
                   %Node{
                     children: [],
                     details: "on paris_polygons_ar_08 as paris",
                     meta: _,
                     type: "Seq Scan",
                     warnings: []
                   },
                   %Node{
                     children: [],
                     details: "on paris_points_ar_08 as paris",
                     meta: _,
                     type: "Seq Scan",
                     warnings: _
                   },
                   %Node{
                     children: [],
                     details: "on paris_linestrings_ar_08 as paris",
                     meta: _,
                     type: "Seq Scan",
                     warnings: _
                   },
                   %Node{
                     children: [],
                     details: "on paris_polygons as paris using idx_paris_polygons_tags",
                     meta: _,
                     type: "Index Scan",
                     warnings: _
                   },
                   %Node{
                     children: [],
                     details: "on paris_points as paris using idx_paris_points_tags",
                     meta: _,
                     type: "Index Scan",
                     warnings: _
                   },
                   %Node{
                     children: [],
                     details: "on paris_linestrings as paris",
                     meta: _,
                     type: "Seq Scan",
                     warnings: _
                   },
                   %Node{
                     children: [],
                     details: "on paris as paris using idx_paris_tags",
                     meta: _,
                     type: "Index Scan",
                     warnings: _
                   }
                 ],
                 details: nil,
                 meta: _,
                 type: "Append",
                 warnings: _
               }
             ],
             details: nil,
             meta: _,
             type: "Result",
             warnings: _
           } = Node.build_tree(plan)
  end

  test "sub_cost/1" do
    plan = List.first(ExplainData.big_plan())["Plan"]
    tree = Node.build_tree(plan)

    cost = Node.sub_cost(tree.children)

    assert Float.round(cost, 2) == 50.12
  end
end
