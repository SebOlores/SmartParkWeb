using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SmartParkWeb
{
    public static class DbHelper
    {
        public static SqlConnection GetConnection()
        {
            string cs = ConfigurationManager.ConnectionStrings["SmartParkDB"].ConnectionString;
            var conn = new SqlConnection(cs);
            conn.Open();
            return conn;
        }

        public static DataTable ExecProc(string procName, params SqlParameter[] prms)
        {
            using (var conn = GetConnection())
            using (var cmd = new SqlCommand(procName, conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                if (prms != null)
                    foreach (var p in prms) cmd.Parameters.Add(p);
                var dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);
                return dt;
            }
        }
    }
}