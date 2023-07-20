<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['ownerid'])&& isset($_POST['recordid'])){
	$ownerid = $_POST['ownerid'];	
	$recordid = $_POST['recordid'];
	$sqlrecorddetails = "SELECT * FROM `tbl_recorddetails` INNER JOIN `tbl_items` ON tbl_recorddetails.item_id = tbl_items.item_id WHERE tbl_recorddetails.owner_id = '$ownerid' AND tbl_recorddetails.recorddetail_id = '$recordid'";
}

//	$sqlcart = "SELECT * FROM `tbl_carts` INNER JOIN `tbl_items` ON tbl_carts.item_id = tbl_items.item_id WHERE tbl_carts.user_id = '$userid'";
//`recorddetail_id`, `record_bill`, `item_id`, `recorddetail_qty`, `recorddetail_paid`, `trader_id`, `owner_id`, `recorddetail_date`

$result = $conn->query($sqlrecorddetails);
if ($result->num_rows > 0) {
    $oderdetails["recorddetails"] = array();
	while ($row = $result->fetch_assoc()) {
        $recorddetailslist = array();
        $recorddetailslist['recorddetail_id'] = $row['recorddetail_id'];
        //$recorddetailslist['record_bill'] = $row['record_bill'];
        $recorddetailslist['item_id'] = $row['item_id'];
        $recorddetailslist['item_name'] = $row['item_name'];
        $recorddetailslist['recorddetail_qty'] = $row['recorddetail_qty'];
        $recorddetailslist['recorddetail_paid'] = $row['recorddetail_paid'];
        $recorddetailslist['trader_id'] = $row['trader_id'];
        $recorddetailslist['owner_id'] = $row['owner_id'];
        $recorddetailslist['recorddetail_date'] = $row['recorddetail_date'];
        array_push($oderdetails["recorddetails"] ,$recorddetailslist);
    }
    $response = array('status' => 'success', 'data' => $oderdetails);
    sendJsonResponse($response);
}else{
     $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}