<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<style>
	div.tab{
		overflow: hidden;
		border: 1px solid #ccc;
		background-color: #f1f1f1;
	}
	div.tab button{
		background-color: inherit;
		float: left;
		border: none;
		outline: none;
		cursor: pointer;
		padding: 14px 16px;
		transition: 0.3s;
	}
	
	div.tab button:hover{
		background-color: #ddd;
		border-radius:3px;
		transform: translateY(-5px);
		box-shadow: 5px 5px 3px #888888;
	}
	
	#new_transaction{
		margin-top: 40px;
	}
	input, select {
		display: block;
		margin-bottom: 1.25em;
		width: 150px;
		border: 1px solid black;
		border-right: 2px solid black;
		border-bottom: 2px solid black;
	}
	#date_range{
		margin-bottom: 20px;
	}
	#date_range input{
		display: inline;
		margin-top: 10px;
		border-radius: 10px;
		box-shadow: 10px 10px 5px #888888
	}
	#date_range select{
		border-radius: 10px;
		box-shadow: 10px 10px 5px #888888
	}
	

</style>
</head>
<body>
	<div class="tab">
			<button onclick="newTransaction()">New Transaction</button>
			<button onclick="transactionDetail()">Transaction Detail</button>
	</div>
	</div>
	<div class="container">
		<div class="form-group" id="add_transaction" >
			<form id="new_transaction">
				<label for="transaction_type">Transaction_Type : </label>
				<select name="transaction_type"  class="form-control" required>
					<option value="">Select</option>
					<option value="sell">Sell</option>
					<option value="buy">Buy</option>
				</select>
				<label for="description">Description : </label>
				<input type="text" name="description" class="form-control" required></input>
				<label for="date">Date : </label>
				<input type="date" name="date"  class="form-control" required></input>
				<label>Payment_Type : </label>
				<input type="text" name="payment_type"  class="form-control" required></input>
				<label for="quantity">Quantity : </label>
				<input type="number" name="quantity"  class="form-control" required></input>
				<label for="price">Price : </label>
				<input type="number" name="price"  class="form-control" required></input>
			</form>
				<button id="add_button" type="button" class="btn btn-primary" disabled = "disabled"   onclick="add()">Add</button>
		</div>
		<div id="transaction_detail" style="display:none">
			<Strong><i>Date Range</i></Strong>
			<br>
			<div id="date_range">
			<form id="range">
				From: <input id="from" name="from" type="date"/>
				To: <input id="to" name="to" type="date"/>
				<select id="display_option">
					<option value="all">All Transactions</option>
					<option value="buy">Buy</option>
					<option value="sell">Sell</option>
				</select>
			</form>
				<button id="display_button" type="button" class="btn btn-primary" disabled = "disabled" onclick="display()">Show</button>
				<button id="summary_button" type="button" class="btn btn-primary" onclick="summary()" style="display:none">Summary</button>
				<br>
			</div>
			<div id="transaction">
				<table id="transaction_tbl" class="table table-hover">
					<tr>
						<th>Transaction_Type</th>
						<th>Description</th>
						<th>Date</th>
						<th>Payment_Type</th>
						<th>Quantity</th>
						<th>Price</th>
						<th>Total_Amount</th>
					</tr>
				</table>
			</div>
		</div>
		<div id="summary" style="display:none">
			<table id="summary_tbl" class="table table-hover" >
				<tr>
					<th>Total Sale</th>
					<th>Total Purchase</th>
				</tr>
			</table>
			<div id="piechart_3d" style="width: 900px; height: 500px; "></div>
		</div>
		</div>
	</div>
	
<script>

	  

	function formValidation(element, button){
		isValid = true;
		$(element).each(function(index){
			if($(this).val()=== ''){
				$(button).prop("disabled", true);
				isValid = false;
			}
		})
		
		if(isValid){
			$(button).prop("disabled", false);
		}
		
	}
	
	
	$("select,input").change(function(){
		formValidation("#new_transaction input, #new_transaction select","#add_button");
		formValidation("#range input","#display_button");
	})
	
	$("input").keyup(function(){
		formValidation("#new_transaction input, #new_transaction select","#add_button");
		formValidation("#range input","#display_button");

	})
	

	function add(){
		
		var value = $("#new_transaction").serialize();
		var url = "add.jsp";
		var posting = $.post( url, value);
		
		posting.done(function(res){
			$("#new_transaction")[0].reset();
			console.log(res);
		});
		
		posting.fail(function(err){
			console.log(err);
		});
	}
	
	function display(){
		$("#transaction").css("display","block");
		$("#transaction_detail #transaction tr td").remove();
		$("#summary_button").css("display","inline");
		$("#summary").css("display","none")
		$("#summary_button").prop("disabled",false);

		var value = $("#range").serialize();
		var url = "display.jsp";
		var posting = $.post( url, value);
		
		posting.done(function(res){
			transactions = JSON.parse(res);
			$.each(transactions,function(index,value){
			console.log($("#display_option").val());
			if( $("#display_option").val()=="buy" && value.transaction_type=="buy"){
				$("#transaction_detail #transaction_tbl").append("<tr><td>" + value.transaction_type + "</td><td>" + value.description + "</td>" 
															+ "<td>" + value.date + "</td><td>" + value.payment_type + "</td>" 
															+ "<td>" + value.quantity + "</td><td>"+"$" + value.price + "</td>"
															+ "<td>" + "$" + parseInt(value.quantity)*parseInt(value.price) + "</td></tr>"
															);
			} else if( $("#display_option").val()=="sell" && value.transaction_type=="sell"){
				$("#transaction_detail #transaction_tbl").append("<tr><td>" + value.transaction_type + "</td><td>" + value.description + "</td>" 
															+ "<td>" + value.date + "</td><td>" + value.payment_type + "</td>" 
															+ "<td>" + value.quantity + "</td><td>"+"$" + value.price + "</td>"
															+ "<td>" + "$" + parseInt(value.quantity)*parseInt(value.price) + "</td></tr>"
															);
			} else if( $("#display_option").val()=="all") {
				$("#transaction_detail #transaction_tbl").append("<tr><td>" + value.transaction_type + "</td><td>" + value.description + "</td>" 
															+ "<td>" + value.date + "</td><td>" + value.payment_type + "</td>" 
															+ "<td>" + value.quantity + "</td><td>"+"$" + value.price + "</td>"
															+ "<td>" + "$" + parseInt(value.quantity)*parseInt(value.price) + "</td></tr>"
															);
			}
			})
			
		});
		
		posting.fail(function(err){
			console.log(err);
		});
		
	}
	
	function summary(){
		$("#transaction").css("display","none");
		$("#summary").css("display","block");
		$("#summary #summary_tbl tr td").remove();
		$("#summary_button").prop("disabled",true);
		total_purchase = 0;
		total_sale = 0;
		
		$.each(transactions,function(index,value){
		
			if( $("#display_option").val()=="buy" && value.transaction_type=="buy"){
					total_purchase = total_purchase + parseInt(value.quantity)*parseInt(value.price);
			} else if( $("#display_option").val()=="sell" && value.transaction_type=="sell"){
					total_sale = total_sale + parseInt(value.quantity)*parseInt(value.price);
			} else if( $("#display_option").val()=="all") {
					if(value.transaction_type=="buy"){
						total_purchase = total_purchase + parseInt(value.quantity)*parseInt(value.price);
					}
					if(value.transaction_type=="sell"){
						total_sale = total_sale + parseInt(value.quantity)*parseInt(value.price);
					}
				
			}
		});
		
		
		$("#summary #summary_tbl").append("<tr><td>$"+total_sale+"</td><td>$"+total_purchase+"</td></tr>");
		
		if(total_purchase>0 || total_sale >0) {
			google.charts.load("current", {packages:["corechart"]});
			google.charts.setOnLoadCallback(drawChart);
		}
	}
	
	  
    function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Volume', ""],
          ['Purchase', total_purchase],
		  ['Sale', total_sale]
		]);

        var options = {
          title: 'Transaction Ratio',
          is3D: true,
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart_3d'));
        chart.draw(data, options);
      }
	function newTransaction(){
		$("#new_transaction")[0].reset();
		formValidation("#new_transaction input, #new_transaction select","#add_button");
		$("#transaction_detail").css("display","none");
		$("#add_transaction").css("display","inline");
		$("#transaction").css("display","block");
		$("#summary").css("display","none");
	}
	
	function transactionDetail(){
		$("#range")[0].reset();
		formValidation("#range input","#display_button");
		$("#summary_button").css("display","none")
		$("#transaction_detail #transaction tr td").remove();
		$("#transaction_detail").css("display","inline");
		$("#add_transaction").css("display","none");
	}
</script>
</body>
<html>