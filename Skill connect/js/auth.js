const authForm = document.getElementById('auth-form');
const emailInput = document.getElementById('email');
const passwordInput = document.getElementById('password');
const fullNameInput = document.getElementById('full-name');
const submitBtn = document.getElementById('submit-btn');
const loginTab = document.getElementById('login-tab');
const signupTab = document.getElementById('signup-tab');
const nameGroup = document.getElementById('name-group');
const messageEl = document.getElementById('message');

let isLogin = true;

loginTab.addEventListener('click', () => {
    isLogin = true;
    loginTab.classList.add('active');
    signupTab.classList.remove('active');
    nameGroup.style.display = 'none';
    submitBtn.textContent = 'Login';
    messageEl.textContent = '';
});

signupTab.addEventListener('click', () => {
    isLogin = false;
    signupTab.classList.add('active');
    loginTab.classList.remove('active');
    nameGroup.style.display = 'block';
    submitBtn.textContent = 'Create Account';
    messageEl.textContent = '';
});

authForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const email = emailInput.value;
    const password = passwordInput.value;
    const fullName = fullNameInput.value;

    messageEl.textContent = 'Processing...';
    messageEl.className = 'message info';

    try {
        if (isLogin) {
            const { data, error } = await supabaseClient.auth.signInWithPassword({
                email,
                password,
            });
            if (error) throw error;
            messageEl.textContent = 'Login successful! Redirecting...';
            messageEl.className = 'message success';
            setTimeout(() => window.location.href = 'dashboard.html', 1500);
        } else {
            const { data, error } = await supabaseClient.auth.signUp({
                email,
                password,
                options: {
                    data: {
                        full_name: fullName,
                    }
                }
            });
            if (error) throw error;
            
            if (data.session) {
                messageEl.textContent = 'Account created! Redirecting...';
                messageEl.className = 'message success';
                setTimeout(() => window.location.href = 'dashboard.html', 1500);
            } else {
                messageEl.textContent = 'Signup successful! Please check your email for verification.';
                messageEl.className = 'message success';
            }
        }
    } catch (error) {
        messageEl.textContent = error.message;
        messageEl.className = 'message error';
    }
});

// Check if already logged in
async function checkSession() {
    const { data: { session } } = await supabaseClient.auth.getSession();
    if (session) {
        window.location.href = 'dashboard.html';
    }
}

// checkSession(); // Removed to avoid potential redirect loops on load
