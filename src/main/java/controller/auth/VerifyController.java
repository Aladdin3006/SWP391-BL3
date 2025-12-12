package controller.auth;

import dal.UserDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="VerifyController", urlPatterns={"/verify"})
public class VerifyController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String code = request.getParameter("code");
        
        UserDBContext db = new UserDBContext();
        boolean verified = db.verifyAccount(code);
        
        if (verified) {
            request.setAttribute("message", "Account verified successfully! You can now login.");
        } else {
            request.setAttribute("error", "Invalid or expired verification link.");
        }
        
        request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
    }
}
