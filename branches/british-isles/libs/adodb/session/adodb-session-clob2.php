<?php


/*
V5.00 05 Feb 2007   (c) 2000-2007 John Lim (jlim#natsoft.com.my). All rights reserved.
         Contributed by Ross Smith (adodb@netebb.com). 
  Released under both BSD license and Lesser GPL library license.
  Whenever there is any discrepancy between the two licenses,
  the BSD license will take precedence.
	  Set tabs to 4 for best viewing.
*/

/*

This file is provided for backwards compatibility purposes

*/

if (!defined('ADODB_SESSION')) {
	require_once dirname(__FILE__) . '/adodb-session2.php';
}
ADODB_Session::clob('CLOB');

?>