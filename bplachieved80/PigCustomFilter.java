package com.bigdata.acadgild;

import java.io.IOException;

import org.apache.pig.FilterFunc;
import org.apache.pig.data.Tuple;

public class PigCustomFilter extends FilterFunc{

	public Boolean exec(Tuple input) throws IOException
	{
		if ( input == null || input.size() == 0 )
			return false;
		if ( input.get(0) == null || input.get(1) == null )
		{
			return false;
		}
		System.out.println("coming inside****");
		System.out.println("field 1"+input.get(0).toString());
		System.out.println("field 2"+input.get(1).toString());
		
		if ( input.get(0).toString().length() == 0 || input.get(1).toString().length() == 0 )
			return false;
		
		int arg1 = Integer.parseInt(input.get(0).toString());
		int arg2 = Integer.parseInt(input.get(1).toString());
		float result = (arg1 * 100)/arg2;
		if ( result >= 80.00 )
			return true;
		return false;
		
	}
} 
