defmodule Lively.Test.Support.ExplainData do
  def single_node_plan,
    do: [
      %{
        "Execution Time" => 0.327,
        "Plan" => %{
          "Actual Loops" => 1,
          "Actual Rows" => 8,
          "Actual Startup Time" => 0.025,
          "Actual Total Time" => 0.118,
          "Alias" => "b0",
          "Local Dirtied Blocks" => 0,
          "Local Hit Blocks" => 0,
          "Local Read Blocks" => 0,
          "Local Written Blocks" => 0,
          "Node Type" => "Seq Scan",
          "Output" => ["id", "title", "inserted_at", "updated_at"],
          "Parallel Aware" => false,
          "Plan Rows" => 20,
          "Plan Width" => 3704,
          "Relation Name" => "books",
          "Schema" => "public",
          "Shared Dirtied Blocks" => 0,
          "Shared Hit Blocks" => 1,
          "Shared Read Blocks" => 0,
          "Shared Written Blocks" => 0,
          "Startup Cost" => 0.0,
          "Temp Read Blocks" => 0,
          "Temp Written Blocks" => 0,
          "Total Cost" => 10.2
        },
        "Planning" => %{
          "Local Dirtied Blocks" => 0,
          "Local Hit Blocks" => 0,
          "Local Read Blocks" => 0,
          "Local Written Blocks" => 0,
          "Shared Dirtied Blocks" => 0,
          "Shared Hit Blocks" => 188,
          "Shared Read Blocks" => 0,
          "Shared Written Blocks" => 0,
          "Temp Read Blocks" => 0,
          "Temp Written Blocks" => 0
        },
        "Planning Time" => 2.488,
        "Settings" => %{},
        "Triggers" => []
      }
    ]

  def big_plan,
    do: [
      %{
        "Plan" => %{
          "Actual Loops" => 1,
          "Actual Rows" => 4,
          "Actual Startup Time" => 0.139,
          "Actual Total Time" => 0.231,
          "Node Type" => "Result",
          "Plan Rows" => 7,
          "Plan Width" => 405,
          "Plans" => [
            %{
              "Actual Loops" => 1,
              "Actual Rows" => 4,
              "Actual Startup Time" => 0.131,
              "Actual Total Time" => 0.218,
              "Node Type" => "Append",
              "Parent Relationship" => "Outer",
              "Plan Rows" => 7,
              "Plan Width" => 405,
              "Plans" => [
                %{
                  "Actual Loops" => 1,
                  "Actual Rows" => 0,
                  "Actual Startup Time" => 0.009,
                  "Actual Total Time" => 0.009,
                  "Alias" => "paris",
                  "Filter" => "(ar_num = 8)",
                  "Index Cond" => "(tags ? 'tourism'::text)",
                  "Index Name" => "idx_paris_tags",
                  "Node Type" => "Index Scan",
                  "Parent Relationship" => "Member",
                  "Plan Rows" => 1,
                  "Plan Width" => 450,
                  "Relation Name" => "paris",
                  "Scan Direction" => "NoMovement",
                  "Startup Cost" => 0.0,
                  "Total Cost" => 8.27
                },
                %{
                  "Actual Loops" => 1,
                  "Actual Rows" => 0,
                  "Actual Startup Time" => 0.001,
                  "Actual Total Time" => 0.001,
                  "Alias" => "paris",
                  "Filter" => "((tags ? 'tourism'::text) AND (ar_num = 8))",
                  "Node Type" => "Seq Scan",
                  "Parent Relationship" => "Member",
                  "Plan Rows" => 1,
                  "Plan Width" => 450,
                  "Relation Name" => "paris_linestrings",
                  "Startup Cost" => 0.0,
                  "Total Cost" => 11.8
                },
                %{
                  "Actual Loops" => 1,
                  "Actual Rows" => 0,
                  "Actual Startup Time" => 0.003,
                  "Actual Total Time" => 0.003,
                  "Alias" => "paris",
                  "Filter" => "(ar_num = 8)",
                  "Index Cond" => "(tags ? 'tourism'::text)",
                  "Index Name" => "idx_paris_points_tags",
                  "Node Type" => "Index Scan",
                  "Parent Relationship" => "Member",
                  "Plan Rows" => 1,
                  "Plan Width" => 450,
                  "Relation Name" => "paris_points",
                  "Scan Direction" => "NoMovement",
                  "Startup Cost" => 0.0,
                  "Total Cost" => 8.27
                },
                %{
                  "Actual Loops" => 1,
                  "Actual Rows" => 0,
                  "Actual Startup Time" => 0.002,
                  "Actual Total Time" => 0.002,
                  "Alias" => "paris",
                  "Filter" => "(ar_num = 8)",
                  "Index Cond" => "(tags ? 'tourism'::text)",
                  "Index Name" => "idx_paris_polygons_tags",
                  "Node Type" => "Index Scan",
                  "Parent Relationship" => "Member",
                  "Plan Rows" => 1,
                  "Plan Width" => 450,
                  "Relation Name" => "paris_polygons",
                  "Scan Direction" => "NoMovement",
                  "Startup Cost" => 0.0,
                  "Total Cost" => 8.27
                },
                %{
                  "Actual Loops" => 1,
                  "Actual Rows" => 0,
                  "Actual Startup Time" => 0.103,
                  "Actual Total Time" => 0.103,
                  "Alias" => "paris",
                  "Filter" => "((tags ? 'tourism'::text) AND (ar_num = 8))",
                  "Node Type" => "Seq Scan",
                  "Parent Relationship" => "Member",
                  "Plan Rows" => 1,
                  "Plan Width" => 513,
                  "Relation Name" => "paris_linestrings_ar_08",
                  "Startup Cost" => 0.0,
                  "Total Cost" => 7.27
                },
                %{
                  "Actual Loops" => 1,
                  "Actual Rows" => 4,
                  "Actual Startup Time" => 0.009,
                  "Actual Total Time" => 0.085,
                  "Alias" => "paris",
                  "Filter" => "((tags ? 'tourism'::text) AND (ar_num = 8))",
                  "Node Type" => "Seq Scan",
                  "Parent Relationship" => "Member",
                  "Plan Rows" => 1,
                  "Plan Width" => 72,
                  "Relation Name" => "paris_points_ar_08",
                  "Startup Cost" => 0.0,
                  "Total Cost" => 5.16
                },
                %{
                  "Actual Loops" => 1,
                  "Actual Rows" => 0,
                  "Actual Startup Time" => 0.007,
                  "Actual Total Time" => 0.007,
                  "Alias" => "paris",
                  "Filter" => "((tags ? 'tourism'::text) AND (ar_num = 8))",
                  "Node Type" => "Seq Scan",
                  "Parent Relationship" => "Member",
                  "Plan Rows" => 1,
                  "Plan Width" => 450,
                  "Relation Name" => "paris_polygons_ar_08",
                  "Startup Cost" => 0.0,
                  "Total Cost" => 1.08
                }
              ],
              "Startup Cost" => 0.0,
              "Total Cost" => 50.11
            }
          ],
          "Startup Cost" => 0.0,
          "Total Cost" => 50.13
        },
        "Execution Time" => 1.238,
        "Planning Time" => 0.92,
        "Triggers" => []
      }
    ]
end
