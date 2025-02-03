<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.annotation.MultipartConfig" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Database.DBConnection" %>

<%
try {
    Part filePart = request.getPart("fileServiceImage");

    // Get the filename from the Part
    String fileName = extractFileName(filePart);

    // Define the directory where you want to save the uploaded file
    String uploadDir = "C:/Users/DARSHAN/Documents/NetBeansProjects/WAD_PL/web/assets/images/"; // Replace with the actual path

    // Create the file path where the uploaded file will be saved
    String filePath = uploadDir + File.separator + fileName;

    // Save the uploaded file to the specified directory
    filePart.write(filePath);

    // Handle service validation and insertion into the database
    String name = request.getParameter("txtSName");
    String desc = request.getParameter("txtaDesc");

    List<String> errors = new ArrayList<>();
    Connection conn = DBConnection.getConnection();

    // No field left blank validation
    if (name.isEmpty() || desc.isEmpty()) {
        errors.add("All fields must be filled.");
    } else {
        if (name.length() < 2 || name.length() > 50) {
            errors.add("Length of service name should be between 2 to 50 characters.");
        }
        if (!name.matches("[A-Za-z ]{2,50}")) {
            errors.add("Service name should contain only alphabets.");
        }

        // serviceName exist check
        String sql = "SELECT serviceName FROM Service WHERE serviceName = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, name);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            errors.add("Service Name already exists. Try another.");
        }

        if (errors.isEmpty()) {
            sql = "INSERT INTO Service(serviceName, description, serviceImg) VALUES(?, ?, ?)";

            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, desc);
            ps.setString(3, fileName); // Save the file name in the database

            if (ps.executeUpdate() == 1) {
                request.getRequestDispatcher("./ViewService.jsp").forward(request, response);
            } else {
                errors.add("Can't add! Please try again.");
            }
        }
        rs.close();
        ps.close();
        conn.close();
    }

    if (!errors.isEmpty()) {
        request.setAttribute("serviceErrors", errors);
        request.getRequestDispatcher("./AddService.jsp").forward(request, response);
    }
} catch (Exception e) {
    // Handle any exceptions that may occur during the file upload process or database operations
    e.printStackTrace();
    // You can add error handling code here
}
%>

<%!
// Helper method to extract the filename from a Part object
private String extractFileName(Part part) {
    String contentDisposition = part.getHeader("content-disposition");
    String[] tokens = contentDisposition.split(";");
    for (String token : tokens) {
        if (token.trim().startsWith("filename")) {
            return token.substring(token.indexOf("=") + 2, token.length() - 1);
        }
    }
    return "";
}
%>
