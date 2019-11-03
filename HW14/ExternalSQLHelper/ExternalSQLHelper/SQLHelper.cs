using System;
using System.Data.SqlTypes;
using System.Text.RegularExpressions;

    public class SQLHelper
    {
        public static bool IsIpAdpress(SqlString strName)
        {
            Match match = Regex.Match(strName.ToString(), @"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}");
            if (match.Success)
                return true;

            return false;
        }
    }
 