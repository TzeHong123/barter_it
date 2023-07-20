<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 6;
if (isset($_POST['pageno'])){
	$pageno = (int)$_POST['pageno'];
}else{
	$pageno = 1;
}
$page_first_result = ($pageno - 1) * $results_per_page;

if (isset($_POST['wishlistuserid'])){
	$wishlistuserid = $_POST['wishlistuserid'];
}else{
	$wishlistuserid = '0';
}

if (isset($_POST['userid'])){
	$userid = $_POST['userid'];	
	$sqlloaditems = "SELECT * FROM `tbl_items` WHERE user_id = '$userid'";
	$sqlwishlist = "SELECT * FROM `tbl_wishlists` WHERE user_id = '$userid'";
}else if (isset($_POST['search'])){
	$search = $_POST['search'];
	$sqlloaditems = "SELECT * FROM `tbl_items` WHERE item_name LIKE '%$search%' 
			 OR item_type LIKE '%$search%' 
			 OR item_state LIKE '%$search%' 
			 OR item_locality LIKE '%$search%'";
	$sqlwishlist = "SELECT * FROM `tbl_wishlists` WHERE user_id = '$wishlistuserid'";
}else{
	$sqlloaditems = "SELECT * FROM `tbl_items`";
	$sqlwishlist = "SELECT * FROM `tbl_wishlists` WHERE user_id = '$wishlistuserid'";
}

if (isset($sqlwishlist)){
	$resultwishlist = $conn->query($sqlwishlist);
	$number_of_result_wishlist = $resultwishlist->num_rows;
	if ($number_of_result_wishlist > 0) {
		$totalwishlist = 0;
		while ($rowwishlist = $resultwishlist->fetch_assoc()) {
			$totalwishlist = $totalwishlist+ $rowwishlist['wishlist_qty'];
		}
	}else{
		$totalwishlist = 0;
	}
}else{
	$totalwishlist = 0;
}

$result = $conn->query($sqlloaditems);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloaditems = $sqlloaditems . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloaditems);


if ($result->num_rows > 0) {
    $items["items"] = array();
	while ($row = $result->fetch_assoc()) {
        $itemlist = array();
        $itemlist['item_id'] = $row['item_id'];
        $itemlist['user_id'] = $row['user_id'];
        $itemlist['item_name'] = $row['item_name'];
        $itemlist['item_type'] = $row['item_type'];
        $itemlist['item_desc'] = $row['item_desc'];
        $itemlist['item_qty'] = $row['item_qty'];
        $itemlist['item_lat'] = $row['item_lat'];
        $itemlist['item_long'] = $row['item_long'];
        $itemlist['item_state'] = $row['item_state'];
        $itemlist['item_locality'] = $row['item_locality'];
	$itemlist['item_date'] = $row['item_date'];
        array_push($items["items"],$itemlist);
    }
     $response = array('status' => 'success', 'data' => $items, 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result", 'wishlistqty'=> $totalwishlist);
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
