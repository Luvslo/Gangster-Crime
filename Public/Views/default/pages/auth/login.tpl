<div class="box">
    <div class="box-header"><i class="fal fa-sign-in"></i>Gangsters Login</div>
    <div class="box-body">
        {% if loginError %}
            <div class="alert alert-danger">{{ loginError }}</div>
        {% endif %}
        <form method="post" action="{{ settings.get('website_url') }}auth/login">
            <input class="form-control" type="text" name="gangster_username" placeholder="Gangster Name" autocomplete="off">
            <input class="form-control" type="password" name="gangster_password" placeholder="Gangster Password" autocomplete="off">
            <input type="hidden" name="token" value="{{ token }}">
            <button class="btn btn-danger btn-sm" type="submit">Log in</button>
            <span class="links">
                Lost <a href="">gangster name</a> or <a href="">gangster password</a>?
            </span>
        </form>
    </div>
</div>