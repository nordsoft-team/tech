package nordsoft;

import java.sql.*;


public class mySql
{
    public static void main(String[] args)
    {
        try
        {
            Class.forName("com.mysql.jdbc.Driver");     //加载MYSQL JDBC驱动程序
            System.out.println("Success loading Mysql Driver!");
        }
        catch (Exception e)
        {
            System.out.print("Error loading Mysql Driver!");
            e.printStackTrace();
        }
        try
        {
            System.out.println("start connecting");
            Connection connect = DriverManager.getConnection(
                    "jdbc:mysql://127.0.0.1:3306/mySql","root","abc123");
            //连接URL为   jdbc:mysql//服务器地址/数据库名  ，后面的2个参数分别是登陆用户名和密码

            System.out.println("Success connect Mysql server!");

            Statement stmt = connect.createStatement();

            ResultSet rs = stmt.executeQuery("select * from database.db");
            //user 为你表的名称
            while (rs.next())
            {

                String uid = rs.getString("stuID");
                String name = rs.getString("stuName");
                String age = rs.getString("sutAge");

                System.out.println("学号:" + uid +""
                        + "\t" + "姓名:" + name + "\t" + "年龄:"+ age + "\n" );
            }
            rs.close();
            connect.close(); // 关闭连接
        }
        catch (Exception e)
        {
            System.out.print("get data error!");
            e.printStackTrace();
        }
    }
}