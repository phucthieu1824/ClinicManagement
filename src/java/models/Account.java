package models;

public class Account {

    public int AccountId;
    public String Username;
    public String Password;
    public String FullName;
    public String Phone;
    public String Email;
    public int RoleId;
    public boolean IsActive;

    public Account() {
    }

    public Account(int AccountId, String Username, String Password, String FullName, String Phone, String Email, int RoleId, boolean IsActive) {
        this.AccountId = AccountId;
        this.Username = Username;
        this.Password = Password;
        this.FullName = FullName;
        this.Phone = Phone;
        this.Email = Email;
        this.RoleId = RoleId;
        this.IsActive = IsActive;
    }

    public int getAccountId() {
        return AccountId;
    }

    public void setAccountId(int AccountId) {
        this.AccountId = AccountId;
    }

    public String getUsername() {
        return Username;
    }

    public void setUsername(String Username) {
        this.Username = Username;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String Password) {
        this.Password = Password;
    }

    public String getFullName() {
        return FullName;
    }

    public void setFullName(String FullName) {
        this.FullName = FullName;
    }

    public String getPhone() {
        return Phone;
    }

    public void setPhone(String Phone) {
        this.Phone = Phone;
    }

    public String getEmail() {
        return Email;
    }

    public void setEmail(String Email) {
        this.Email = Email;
    }

    public int getRoleId() {
        return RoleId;
    }

    public void setRoleId(int RoleId) {
        this.RoleId = RoleId;
    }

    public boolean isIsActive() {
        return IsActive;
    }

    public void setIsActive(boolean IsActive) {
        this.IsActive = IsActive;
    }
}
