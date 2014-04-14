Feature:Place Order With Discount

Background: Setup coupon 
Given coupon template setup
| code                      | script                                      |
| x_off_for_y_spent         | origin >= params[:threshold]? params[:off] : 0 |
| x_off_for_every_y_spent   | origin / params[:threshold] * params[:off]    |
| x_off_for_y_ordered       | temp = 0; quantities.each_with_index {|quantity, i| temp += prices[i]*params[:off] if quantity >= params[:threshold] }; return temp |
| 2_stage_x_off_for_y_spent | return params[:off2] if origin >= params[:threshold2]; return params[:off1] if origin >= params[:threshold1]; return 0;|
Then I publish coupons named "1_off_for_3_spent" with template "x_off_for_y_spent"
| key       | value |
| threshold | 3     |
| off       | 1     |
And I publish coupons named "1_off_for_3_every_spent" with template "x_off_for_every_y_spent"
| key       | value |
| threshold | 3     |
| off       | 1     |
And I publish coupons named "1_off_for_2_ordered" with template "x_off_for_y_ordered"
| key       | value |
| threshold | 2     |
| off       | 1     |
And I publish coupons named "3_off_for_6_spent,1_off_for_3_spent" with template "2_stage_x_off_for_y_spent"
| key       | value |
| threshold1 | 3     |
| off1        | 1     |
| threshold2 | 6     |
| off2        | 3     |

Scenario:Place Order without coupon

When I order drink with
|drink|milk|size| price| quantity |
|latte|semi|large| 3 | 1 |
Then an order should be placed
And the cost is 3

Scenario:Place Order with coupon:1 off for 3 spent

Given I have a coupon "1_off_for_3_spent"
When I order drink with
|drink|milk|size| price| quantity |
|latte|semi|large| 3 | 2 |
|cappuccino|semi|large| 4 | 2 |
Then an order should be placed
And the cost is 13

Scenario:Place Order with coupon:1 off for 3 spent, but not satisfied

Given I have a coupon "1_off_for_3_spent"
When I order drink with
|drink|milk|size| price| quantity |
|latte|semi|small| 2 | 1 |
Then an order should be placed
And the cost is 2

Scenario:Place Order with coupon:1 off for every 3 spent

Given I have a coupon "1_off_for_3_every_spent"
When I order drink with
|drink|milk|size| price| quantity |
|latte|semi|large| 3 | 2 |
|cappuccino|semi|large| 4 | 2 |
Then an order should be placed
And the cost is 10

Scenario:Place Order with coupon:1 off for every 3 spent, but not satisfied

Given I have a coupon "1_off_for_3_every_spent"
When I order drink with
|drink|milk|size| price| quantity |
|latte|semi|small| 2 | 1 |
Then an order should be placed
And the cost is 2

Scenario:Place Order with coupon:1 off for 2 ordered

Given I have a coupon "1_off_for_2_ordered"
When I order drink with
|drink|milk|size| price| quantity |
|latte|semi|large| 3 | 4 |
|cappuccino|semi|large| 4 | 2 |
Then an order should be placed
And the cost is 13

Scenario:Place Order with coupon:1 off for 2 ordered, but not satisfied

Given I have a coupon "1_off_for_2_ordered"
When I order drink with
|drink|milk|size| price| quantity |
|latte|semi|large| 3 | 1 |
|cappuccino|semi|large| 4 | 1 |
Then an order should be placed
And the cost is 7

Scenario:Place Order with coupon stage1:3 off for 6 spent,1 off for 3 spent

Given I have a coupon "3_off_for_6_spent,1_off_for_3_spent"
When I order drink with
|drink|milk|size| price| quantity |
|latte|semi|large| 3 | 1 |
Then an order should be placed
And the cost is 2

Scenario:Place Order with coupon stage2:3 off for 6 spent,1 off for 3 spent

Given I have a coupon "3_off_for_6_spent,1_off_for_3_spent"
When I order drink with
|drink|milk|size| price| quantity |
|latte|semi|large| 3 | 3 |
Then an order should be placed
And the cost is 6

Scenario:Place Order with coupon stage2:3 off for 6 spent,1 off for 3 spent, but not satisfied

Given I have a coupon "3_off_for_6_spent,1_off_for_3_spent"
When I order drink with
|drink|milk|size| price| quantity |
|latte|semi|small| 2 | 1 |
Then an order should be placed
And the cost is 2