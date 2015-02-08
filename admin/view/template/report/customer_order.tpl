<?php echo $header; ?>
<div id="content">
	<div class="breadcrumb">
		<?php foreach ($breadcrumbs as $breadcrumb) { ?>
		<?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
		<?php } ?>
	</div>
	<div class="box">
		<div class="heading">
			<h1><img src="view/image/report.png" alt="" /> <?php echo $heading_title; ?></h1>
		</div>
		<div class="content">
			<table class="form">
				<tr>
					<td><?php echo $entry_date_start; ?>
						<input type="text" name="filter_date_start" value="<?php echo $filter_date_start; ?>" id="date-start" size="12" /></td>
					<td><?php echo $entry_date_end; ?>
						<input type="text" name="filter_date_end" value="<?php echo $filter_date_end; ?>" id="date-end" size="12" /></td>
					<td><?php echo $entry_status; ?>
						<select name="filter_order_status_id">
							<option value="0"><?php echo $text_all_status; ?></option>
							<?php foreach ($order_statuses as $order_status) { ?>
							<?php if ($order_status['order_status_id'] == $filter_order_status_id) { ?>
							<option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
							<?php } else { ?>
							<option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
							<?php } ?>
							<?php } ?>
						</select></td>
					<td style="text-align: right;">
						<a onclick="exportToCsv();" class="button"><?php echo $button_export; ?></a>
						<a onclick="filter();" class="button"><?php echo $button_filter; ?></a>
					</td>
				</tr>
			</table>
			<table class="list">
				<thead>
					<tr>
						<td class="left"><?php echo $column_customer; ?></td>
						<td class="left"><?php echo $column_email; ?></td>
						<td class="left"><?php echo $column_customer_group; ?></td>
						<td class="left"><?php echo $column_status; ?></td>
						<td class="right"><?php echo $column_orders; ?></td>
						<td class="right"><?php echo $column_products; ?></td>
						<td class="right"><?php echo $column_total; ?></td>
						<td class="right"><?php echo $column_action; ?></td>
					</tr>
				</thead>
				<tbody>
					<?php if ($customers) { ?>
					<?php foreach ($customers as $customer) { ?>
					<tr data_customer_id="<?php echo $customer['customer_id']; ?>">
						<td class="left"><?php echo $customer['customer']; ?></td>
						<td class="left"><?php echo $customer['email']; ?></td>
						<td class="left"><?php echo $customer['customer_group']; ?></td>
						<td class="left"><?php echo $customer['status']; ?></td>
						<td class="right"><?php echo $customer['orders']; ?></td>
						<td class="right"><?php echo $customer['products']; ?></td>
						<td class="right"><?php echo $customer['total']; ?></td>
						<td class="right"><?php foreach ($customer['action'] as $action) { ?>
							[ <a id="action_<?php echo $action['name']; ?>" href="<?php echo $action['href']; ?>"><?php echo $action['text']; ?></a> ]
							<?php } ?></td>
					</tr>
					<?php } ?>
					<?php } else { ?>
					<tr>
						<td class="center" colspan="8"><?php echo $text_no_results; ?></td>
					</tr>
					<?php } ?>
				</tbody>
			</table>
			<div class="pagination"><?php echo $pagination; ?></div>
		</div>
	</div>
	<div class="box box-customer" hidden>
		<div class="heading">
			<h1>Customer: <span></span></h1>
		</div>
		<div class="content">
			<table class="list">
				<thead>
					<tr>
						<td class="right">Order ID</td>
						<td class="right">Order Status ID</td>
						<td class="right">Currency</td>
						<td class="right">Total</td>
						<td class="right">Date Added</td>
						<td class="right">Date Modified</td>
						<td class="right">Referrer ID</td>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>
<script type="text/javascript"><!--
/////////////////////////////////////////////////////////////////////////////////
function exportToCsv () {
	location = document.URL + '&export';
}
/////////////////////////////////////////////////////////////////////////////////
//--></script>
<script type="text/javascript"><!--
function filter() {
	url = 'index.php?route=report/customer_order&token=<?php echo $token; ?>';

	var filter_date_start = $('input[name=\'filter_date_start\']').attr('value');

	if (filter_date_start) {
		url += '&filter_date_start=' + encodeURIComponent(filter_date_start);
	}

	var filter_date_end = $('input[name=\'filter_date_end\']').attr('value');

	if (filter_date_end) {
		url += '&filter_date_end=' + encodeURIComponent(filter_date_end);
	}

	var filter_order_status_id = $('select[name=\'filter_order_status_id\']').attr('value');

	if (filter_order_status_id != 0) {
		url += '&filter_order_status_id=' + encodeURIComponent(filter_order_status_id);
	}

	location = url;
}
//--></script>
<script type="text/javascript"><!--
$(document).ready(function() {
	$('#date-start').datepicker({dateFormat: 'yy-mm-dd'});

	$('#date-end').datepicker({dateFormat: 'yy-mm-dd'});

	///////////////////////////////////////////////////////////////////////////////
	// view button event handler
	$('a#action_view').click(function () {
		var sCustomerId = $(this).closest('tr').attr('data_customer_id');
		var sUrl = 'index.php?route=report/customer_order&token=<?php echo $token; ?>&customer_id=' + sCustomerId;
		$.get(sUrl, function (data) {
			var data = $.parseJSON(data);
			if (data) {
				// display data
				var c = data[0].firstname + ' ' + data[0].lastname + ' (' + data[0].customer_id + ')';
				$('.box.box-customer .heading h1 span').text(c);
				$('.box.box-customer').show();
				var s = _.template(sCustomerOrderTemplate) ({
					orders: data
				});
				$('.box.box-customer .content table>tbody').html(s);
			}
		})
		return false;
	});

	var sCustomerOrderTemplate =
		'<% _.each(orders, function (order) { %>\
			<tr>\
				<td class="right"><%= order.order_id %></td>\
				<td class="right"><%= order.order_status_id %></td>\
				<td class="right"><%= order.currency_code %></td>\
				<td class="right"><%= order.total %></td>\
				<td class="right"><%= order.date_added %></td>\
				<td class="right"><%= order.date_modified %></td>\
				<td class="right"><%= order.referrer_id %></td>\
			</tr>\
		<% }); %>';
});
//--></script>
<?php echo $footer; ?>