<?php
/**
 * $Project: GeoGraph $
 * $Id$
 * 
 * GeoGraph geographic photo archive project
 * This file copyright (C) 2005 Paul Dixon (paul@elphin.com)
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
* Provides the GridShader class
*
* @package Geograph
* @author Paul Dixon <paul@elphin.com>
* @version $Revision$
*/


/**
* Grid shader class
*
* Can process a PNG image of 1km pixels and create/update database grid squares
* @package Geograph
*/
class GridShader
{
	var $db=null;
	
	/**
	* internal function returns the grid reference by looking for
	* suitable gridsquares in the gridprefix table.
	*/
	function _getGridRef($x, $y, $reference_index)
	{
		$gridref="";
		
		//find all grid boxes in which the coordinate falls
		$sql="select prefix,origin_x,origin_y from gridprefix where ".
			"$x between origin_x and (origin_x+width-1) and ".
			"$y between origin_y and (origin_y+height-1) and ".
			"reference_index=$reference_index";
		
		$recordSet = &$this->db->Execute($sql);
		if (!$recordSet->EOF) 
		{
			$gridref=sprintf("%s%02d%02d", 
				$recordSet->fields[0],
				$x-$recordSet->fields[1],
				$y-$recordSet->fields[2]);
			
		}
		$recordSet->Close(); 
		
		return $gridref;
	}
	
	/**
	* adds or updates squares
	*/
	function process($imgfile, $x_offset, $y_offset, $reference_index, $clearexisting)
	{
		if (file_exists($imgfile))
		{
			$img=imagecreatefrompng($imgfile);
			if ($img)
			{
				$this->db = NewADOConnection($GLOBALS['DSN']);
				if (!$this->db) die('Database connection failed');   
						
				
				$imgw=imagesx($img);
				$imgh=imagesy($img);
				

				$this->_trace("Image is {$imgw}km x {$imgh}km");

				$created=0;
				$updated=0;
				$untouched=0;
				$skipped=0;
				
				$lastpercent=-1;
				for ($imgy=0; $imgy<$imgh; $imgy++)
				{
					//output some progress
					$percent=round(($imgy*100)/$imgh);
					$percent=round($percent/5)*5;
					if ($percent!=$lastpercent)
					{
						$this->_trace("{$percent}% completed...");
						$lastpercent=$percent;
					}
					
					for ($imgx=0; $imgx<$imgw; $imgx++)
					{
						//get colour of pixel 
						//255=white, 0% land
						//000=black, 100% land
						$col=imagecolorat ($img, $imgx, $imgy);
						$percent_land=round(((255-$col)*100)/255);
						
						//now lets figure out the internal grid ref
						$gridx=$x_offset + $imgx;
						$gridy=$y_offset + ($imgh-$imgy-1);
						
						$gridref=$this->_getGridRef($gridx,$gridy,$reference_index);

						//$this->_trace("img($imgx,$imgy) = grid($gridx,$gridy) $percent_land%");
						
						//ok, that's everything we need - can we obtain an existing grid square
						$square = $this->db->GetRow("select gridsquare_id,percent_land from gridsquare where x='$gridx' and y='$gridy'");	
					##no need to check this as this is the first import (and its rather expensive!)	
						
						if (is_array($square) && count($square))
						{
							if (($square['percent_land']!=$percent_land) &&
							    ($clearexisting || ($square['percent_land']==0)))
							{
								
								$sql="update gridsquare set grid_reference='{$gridref}', ".
									"reference_index='$reference_index', ".
									"percent_land='$percent_land' ".
									"where gridsquare_id={$square['gridsquare_id']}";
								$this->db->Execute($sql);
								$updated++;
							}
							else
							{
								$untouched++;
							}
						}
						else
						{
							//we only create squares for land
							if ($percent_land>0)
							{
								$sql="insert into gridsquare (grid_reference,reference_index,x,y,percent_land) ".
									"values('{$gridref}','{$reference_index}',$gridx,$gridy,$percent_land)";
								$this->db->Execute($sql);

								$created++;
							}
							else
							{
								$skipped++;
							}
						}
						
			
					}
				
				}
				imagedestroy($img);
				
				$this->_trace("Setting land flags for gridprefixes");
				$prefixes = $this->db->GetAll("select * from gridprefix");	
				foreach($prefixes as $idx=>$prefix)
				{
					
					$minx=$prefix['origin_x'];
					$maxx=$prefix['origin_x']+$prefix['width']-1;
					$miny=$prefix['origin_y'];
					$maxy=$prefix['origin_y']+$prefix['height']-1;
					
					
					$count=$this->db->GetOne("select count(*) from gridsquare where ".
						"x between $minx and $maxx and ".
						"y between $miny and $maxy and ".
						"reference_index={$prefix['reference_index']} and ".
						"percent_land>0");

					//$this->_trace("{$prefix['prefix']} $minx,$miny to $maxx,$maxy has $count");
					
					$this->db->query("update gridprefix set landcount=$count where ".
						"reference_index={$prefix['reference_index']} and ".
						"prefix='{$prefix['prefix']}'");
				}
				
				
				$this->_trace("$created new squares created");
				$this->_trace("$updated squares updated with new land percentage");
				$this->_trace("$untouched squares examined but left untouched");
				$this->_trace("$skipped squares were all water and not created");

				
				
			}
			else
			{
				$this->_err("$imgfile is not a valid PNG"); 
			}
		}
		else
		{
				$this->_err("$imgfile doesn't exist"); 
		}
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

?>