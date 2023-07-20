<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
//SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate FROM Orders INNER JOIN Customers ON Orders.CustomerID=Customers.CustomerID;


if (isset($_POST['userid'])){
	$userid = $_POST['userid'];	
	$sqlwishlist = "SELECT * FROM `tbl_wishlists` INNER JOIN `tbl_items` ON tbl_wishlists.item_id = tbl_items.item_id WHERE tbl_wishlists.user_id = '$userid'";
}

$result = $conn->query($sqlwishlist);
if ($result->num_rows > 0) {
    $wishlistitems["wishlists"] = array();
	while ($row = $result->fetch_assoc()) {
        $wishList = array();
        $wishList['wishlist_id'] = $row['wishlist_id'];
        $wishList['item_id'] = $row['item_id'];
        $wishList['item_name'] = $row['item_name'];
        //$wishList['item_status'] = $row['item_status'];
        $wishList['item_type'] = $row['item_type'];
        $wishList['item_desc'] = $row['item_desc'];
        $wishList['item_qty'] = $row['item_qty'];
        $wishList['wishlist_qty'] = $row['wishlist_qty'];
        $wishList['user_id'] = $row['user_id'];
        $wishList['owner_id'] = $row['owner_id'];
        $wishList['wishlist_date'] = $row['wishlist_date'];
        array_push($wishlistitems["wishlists"] ,$wishList);
    }
    $response = array('status' => 'success', 'data' => $wishlistitems);
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