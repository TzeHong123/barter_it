<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['traderid']) && isset($_POST['recordid'])){
	$traderid = $_POST['traderid'];	
	$recordid = $_POST['recordid'];
	$ownerid = $_POST['ownerid'];
	$sqlrecorddetails = "SELECT * FROM `tbl_recorddetails` INNER JOIN `tbl_items` ON tbl_recorddetails.item_id = tbl_items.item_id WHERE tbl_recorddetails.trader_id = '$traderid' AND tbl_recorddetails.recorddetail_id = '$recordid' AND tbl_recorddetails.owner_id = '$ownerid'";
        
        
        
}else{
    $sqlrecorddetails = "NA";
}

//	$sqlwishlist = "SELECT * FROM `tbl_wishlist` INNER JOIN `tbl_items` ON tbl_wishlists.item_id = tbl_items.item_id WHERE tbl_wishlists.user_id = '$userid'";
//`recorddetail_id`, `record_id`, `item_id`, `recorddetail_qty`, `recorddetail_paid`, `trader_id`, `owner_id`, `recorddetail_date`

$result = $conn->query($sqlrecorddetails);
if ($result->num_rows > 0) {
    $oderdetails["recorddetails"] = array();
	while ($row = $result->fetch_assoc()) {
        $recorddetailslist = array();
        $recorddetailslist['recorddetail_id'] = $row['recorddetail_id'];
        //$recorddetailslist['record_id'] = $row['record_id'];
        $recorddetailslist['item_id'] = $row['item_id'];
        $recorddetailslist['item_name'] = $row['item_name'];
        $recorddetailslist['recorddetail_qty'] = $row['recorddetail_qty'];
        $recorddetailslist['recorddetail_paid'] = $row['recorddetail_paid'];
        $recorddetailslist['trader_id'] = $row['trader_id'];
        $recorddetailslist['owner_id'] = $row['owner_id'];
        $recorddetailslist['recorddetail_date'] = $row['recorddetail_date'];
        array_push($oderdetails["recorddetails"] ,$recorddetailslist);
    }
    $response = array('status' => 'success', 'data' => $oderdetails,'mysql'=>$sqlrecorddetails);
    sendJsonResponse($response);
}else{
     $response = array('status' => 'failed', 'data' => null, 'mysql'=> $sqlrecorddetails);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}