package controller;

import dal.DoctorDAO;
import models.Account;
import models.Visit;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class DoctorDashboardController extends HttpServlet {

    private final DoctorDAO doctorDAO = new DoctorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account accUser = (Account) session.getAttribute("accUser");

        if (accUser == null) {
            accUser = new Account();
            accUser.setAccountId(2);
            accUser.setRoleId(2); // Gán Role ID Bác Sĩ
            accUser.setFullName("BS. Nguyễn Văn Hùng");
            session.setAttribute("accUser", accUser);
        }

        int doctorId = accUser.getAccountId();
        List<Visit> queueList = doctorDAO.getQueueVisits(doctorId);

        long waitingCount = queueList.stream().filter(v -> "WAITING".equals(v.getStatus())).count();
        long examiningCount = queueList.stream().filter(v -> "EXAMINING".equals(v.getStatus())).count();

        request.setAttribute("queueList", queueList);
        request.setAttribute("waitingCount", waitingCount);
        request.setAttribute("examiningCount", examiningCount);

        request.getRequestDispatcher("/WEB-INF/views/doctor/dashboard.jsp").forward(request, response);
    }
}