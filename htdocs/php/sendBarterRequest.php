<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$wishlistid = $_POST['wishlistid'];
$traderid = $_POST['userid'];
$ownerid = $_POST['ownerid'];
$recorddetail_paid = 3;
$newstatus = $_POST['status'];
$itemid = $_POST['itemid'];
$recordqty = $_POST['itemqty'];


$sql = "INSERT INTO `tbl_records` (`wishlist_id`, `trader_id`, `owner_id`, `record_status`) VALUES ('$wishlistid', '$traderid','$ownerid','$newstatus')";

 $sqlrecorddetails = "INSERT INTO `tbl_recorddetails`(`item_id`, `recorddetail_qty`, `recorddetail_paid`, `trader_id`, `owner_id`) VALUES ('$itemid','$recordqty','$recorddetail_paid','$traderid','$ownerid')";
                $conn->query($sqlrecorddetails);
                $sqlupdateitemqty = "UPDATE `tbl_items` SET `item_qty`= (item_qty - $recordqty) WHERE `item_id` = '$itemid'";
                $conn->query($sqlupdateitemqty);


if ($conn->query($sql) === TRUE) {
		$response = array('status' => 'success', 'data' => $sql);
		sendJsonResponse($response);
	}else{
		$response = array('status' => 'failed', 'data' => $sql);
		sendJsonResponse($response);
	}




function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>