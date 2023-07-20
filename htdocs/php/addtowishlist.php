<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$itemid = $_POST['item_id'];
$wishlistqty = $_POST['wishlist_qty'];
//$wishlistprice = $_POST['wishlist_price'];
$userid = $_POST['userid'];
$ownerid = $_POST['ownerid'];

$checkitemid = "SELECT * FROM `tbl_wishlists` WHERE `user_id` = '$userid' AND  `item_id` = '$itemid'";
$resultqty = $conn->query($checkitemid);
$numresult = $resultqty->num_rows;
if ($numresult > 0) {
	$sql = "UPDATE `tbl_wishlists` SET `wishlist_qty`= (wishlist_qty + $wishlistqty) WHERE `user_id` = '$userid' AND  `item_id` = '$itemid'";
}else{
	$sql = "INSERT INTO `tbl_wishlists`(`item_id`, `wishlist_qty`, `user_id`, `owner_id`) VALUES ('$itemid','$wishlistqty','$userid','$ownerid')";
}

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