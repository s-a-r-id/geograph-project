<?php
/**
 * $Project: GeoGraph $
 * $Id$
 * 
 * GeoGraph geographic photo archive project
 * This file copyright (C) 2005  Barry Hunter (geo@barryhunter.co.uk)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */



/**
* Provides the SearchCriteria class
*
* @package Geograph
* @author Barry Hunter <geo@barryhunter.co.uk>
* @version $Revision$
*/


/**
* SearchCriteria
*
* 
* @package Geograph
*/
class SearchCriteria
{
	var $db=null;
	
	/**
	* text representing this search
	*/
	var $searchq;
	
	/**
	* centeroid of search (supplied or calculated)
	*/
	var $x;
  	var $y;
	
	var $resultsperpage;
	var $displayclass;
	
	
	function getSQLParts(&$sql_fields,&$sql_order,&$sql_where) 
	{
		$x = $this->x;
		$y = $this->y;
		if ($x > 0 && $y > 0) {
						
			$sql_fields .= ", ((gs.x - $x) * (gs.x - $x) + (gs.y - $y) * (gs.y - $y)) as dist_sqd";
			$sql_order .= " dist_sqd ";
		} else if ($this->orderby) {
			switch ($this->orderby) {
				case "random":
					$sql_order .= " rand({$this->crt_timestamp}) ";
					break;
				case "dist_sqd":
					break;
				default:
					$sql_order .= $this->orderby;
			}
			
			
		}
	
		$sql_where = '';
		if (!empty($this->limit1)) {
			if (strpos($this->limit1,'!') === 0) {
				$sql_where = "gi.user_id != ".preg_replace('/^!/','',$this->limit1);
			} else {
				$sql_where = "gi.user_id = ".($this->limit1);
			}
		} 
		if (!empty($this->limit2)) {
			if ($sql_where) {
				$sql_where .= " and ";
			}
			$statuslist="'".implode("','", explode(',',$this->limit2))."'";
			$sql_where .= "moderation_status in ($statuslist) ";
		} 
		if (!empty($this->limit3)) {
			if ($sql_where) {
				$sql_where .= " and ";
			}
			$sql_where .= "imageclass = '".addslashes($this->limit3)."' ";
		} 
		if (!empty($this->limit4)) {
			if ($sql_where) {
				$sql_where .= " and ";
			}
			$sql_where .= "reference_index = ".($this->limit4)." ";
		} 
		if (!empty($this->limit5)) {
			if ($sql_where) {
				$sql_where .= " and ";
			}
			
			$db = $this->_getDB();
			
			$prefix = $db->GetRow("select * from gridprefix where prefix=".$db->Quote($this->limit5));	
			
			$sql_where .= sprintf("x between %d and %d and y between %d and %d",$prefix['origin_x'],$prefix['origin_x']+$prefix['width']-1,$prefix['origin_y'],
			$prefix['origin_y']+$prefix['height']-1);
			
			if (empty($this->limit4))
				$sql_where .= " and reference_index = ".$prefix['reference_index']." ";
			
		}
	
	}
	
	
	
	/**
	* return true if instance references a valid search
	*/
	function isValid()
	{
		return isset($this->searchq);
	}

	/**
	* assign members from recordset containing required members
	*/
	function loadFromRecordset(&$rs)
	{
		$this->_clear();
		$this->_initFromArray($rs->fields);
		return $this->isValid();
	}

	/**
	 * clear all member vars
	 * @access private
	 */
	function _clear()
	{
		$vars=get_object_vars($this);
		foreach($vars as $name=>$val)
		{
			if ($name!="db")
				unset($this->$name);
		}
	}
	
	/**
	* assign members from array containing required members
	*/
	function _initFromArray(&$arr)
	{
		foreach($arr as $name=>$value)
		{
			if (!is_numeric($name))
				$this->$name=$value;						
		}
		
	}
	
	/**
	 * get stored db object, creating if necessary
	 * @access private
	 */
	function &_getDB()
	{
		if (!is_object($this->db))
			$this->db=NewADOConnection($GLOBALS['DSN']);
		if (!$this->db) die('Database connection failed');  
		return $this->db;
	}

	/**
	 * set stored db object
	 * @access private
	 */
	function _setDB(&$db)
	{
		$this->db=$db;
	}
	
	function _trace($msg)
	{
		echo "$msg<br/>";
		flush();
	}	
	function _err($msg)
	{
		echo "<p><b>Error:</b> $msg</p>";
		flush();
	}
	
}

class SearchCriteria_GridRef extends SearchCriteria
{
	
}



class SearchCriteria_Text extends SearchCriteria
{
	function getSQLParts(&$sql_fields,&$sql_order,&$sql_where) {
		parent::getSQLParts($sql_fields,$sql_order,$sql_where);
		$db = $this->_getDB();
		if ($sql_where) {
			$sql_where .= " and ";
		}
		$sql_where .= " gi.title LIKE ".$db->Quote('%'.$this->searchq.'%');
	}
}

class SearchCriteria_All extends SearchCriteria
{
	function getSQLParts(&$sql_fields,&$sql_order,&$sql_where) {
		parent::getSQLParts($sql_fields,$sql_order,$sql_where);
		
		if (!$this->orderby)
			$sql_order .= " rand({$this->crt_timestamp}) ";
	}
}

class SearchCriteria_Placename extends SearchCriteria
{
	var $is_multiple = false;
	var $matches;
	var $placename;
	
	function setByPlacename($placename) {
		global $places; //only way to get the array into the compare functions
		$db = $this->_getDB();
		
		if (is_numeric($placename)) {
			$places = $db->GetAll("select full_name,dsg,e,n,reference_index from loc_placenames where id=".$db->Quote($placename));	
		
		} else {
			$places = $db->GetAll("select full_name,dsg,e,n,reference_index from loc_placenames where full_name=".$db->Quote($placename));	
		}
		
		
		
		if (count($places) == 1) {
			$origin = $db->CacheGetRow(100*24*3600,"select origin_x,origin_y from gridprefix where reference_index=".$places[0]['reference_index']." order by origin_x,origin_y limit 1");	

			$this->x = intval($places[0]['e']/1000) + $origin['origin_x'];
			$this->y = intval($places[0]['n']/1000) + $origin['origin_y'];
			$this->placename = $places[0]['full_name'];
			$this->searchq = $places[0]['full_name'];
		} else {
			$places = $db->GetAll("select
				id,
				full_name,
				dsg,
				'populated place' as dsg_name,
				loc_placenames.reference_index,
				loc_adm1.name as adm1_name
			from 
				loc_placenames
				left join loc_adm1 on (loc_placenames.adm1 = loc_adm1.adm1 and loc_placenames.reference_index = loc_adm1.reference_index)
			where
				dsg = 'PPL' AND (
				full_name LIKE ".$db->Quote('%'.$placename.'%')."
				OR SOUNDEX(".$db->Quote($placename).") = SOUNDEX(full_name) )
			limit 20");		
			if (count($places) < 10) {
				$places = array_merge($places,$db->GetAll("select 
					id, 
					full_name,
					dsg,
					loc_dsg.name as dsg_name,
					loc_placenames.reference_index,
					loc_adm1.name as adm1_name
				from 
					loc_placenames
					inner join loc_dsg on (loc_placenames.dsg = loc_dsg.code) 
					left join loc_adm1 on (loc_placenames.adm1 = loc_adm1.adm1 and loc_placenames.reference_index = loc_adm1.reference_index)
				where
					dsg != 'PPL' AND (
					full_name LIKE ".$db->Quote('%'.$placename.'%')."
					OR SOUNDEX(".$db->Quote($placename).") = SOUNDEX(full_name) )
				LIMIT 20") );				
			}	
			if (count($places)) {
				$this->matches = $places;
				$this->is_multiple = true;
				$this->searchq = $placename;
			}
		}
	}
}

class SearchCriteria_Postcode extends SearchCriteria
{
	function setByPostcode($code) {
		$db = $this->_getDB();
		
		$postcode = $db->GetRow("select e,n,reference_index from loc_postcodes where code=".$db->Quote($code));	
		
		$origin = $db->CacheGetRow(100*24*3600,"select origin_x,origin_y from gridprefix where reference_index=".$postcode['reference_index']." order by origin_x,origin_y limit 1");	

		$this->x = intval($postcode['e']/1000) + $origin['origin_x'];
		$this->y = intval($postcode['n']/1000) + $origin['origin_y'];
	}
}

class SearchCriteria_County extends SearchCriteria
{
	var $county_name;
	function setByCounty($county_id) {
		$db = $this->_getDB();
		
		$county = $db->GetRow("select e,n,name,reference_index from loc_counties where county_id=".$db->Quote($county_id));	
	
		//get the first gridprefix with the required reference_index
		//after ordering by x,y - you'll get the bottom
		//left gridprefix, and hence the origin

		$origin = $db->CacheGetRow(100*24*3600,"select origin_x,origin_y from gridprefix where reference_index=".$county['reference_index']." order by origin_x,origin_y limit 1");	

		$this->x = intval($county['e']/1000) + $origin['origin_x'];
		$this->y = intval($county['n']/1000) + $origin['origin_y'];
		$this->county_name = $county['name'];
	}
}

?>