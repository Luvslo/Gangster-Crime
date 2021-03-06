{% extends 'default/layouts/loggedin.tpl' %}
{% block body %}
<div class="game-body">
    <div class="row">
        <div class="col-4 col-md-1 pt-1">
            <ul class="pagination pagination-sm">
                <li class="page-item active"><a class="page-link" href="" tabindex="-1">1</a></li>
                <li class="page-item"><a class="page-link" href="#">2</a></li>
                <li class="page-item"><a class="page-link" href="#">3</a></li>
            </ul>
        </div>
        <div class="col-md-3 pt-2 d-none d-md-block">
            <span class="fa fa-envelope text-white mr-1"></span>
            <span class="small">{{ count | number_format }}/200 Messages</span>
        </div>
        <div class="col-8 col-md-8 text-right">
            <a href="" class="btn btn-dark"><i class="fas fa-ban text-danger mr-1"></i>Block Filter</a>
            <a href="{{ settings.get('website_url') }}messaging/saved" class="btn btn-dark"><i class="fas fa-star text-warning mr-1"></i>Saved</a>
        </div>
    </div>
</div>
<form method="post" action="{{ settings.get('website_url') }}messaging/actions">
{% for message in messages %}
<div class="game-body">
    <div class="row mb-2">
        <div class="col-6">
            <p class="small">Message from {{ message.from.data().profile | raw }}</p>
        </div>
        <div class="col-6 text-right">
            <p class="small">{{ message.message.M_date }}</p>
        </div>
    </div>
    <div class="row mb-2">
        <div class="col-12 col-md-10 align-self-center text-center text-md-left">
            <p class="small">{{ message.message.M_text | raw }}</p>
        </div>
        <div class="d-none d-md-block col-md-2 text-right">
            <img src="{{ settings.get('website_url') }}{{ message.from.data().avatar }}" class="img-fluid" style="width: 75px;height:75px">
        </div>
    </div>
    <div class="text-center text-md-left">
        <input type="hidden" name="message" value="{{ message.message.id }}">
        <input type="submit" class="btn btn-dark" name="delete" value="Delete">
        <input type="submit" class="btn btn-dark" name="save" value="Save">
        {% if message.from.data().name != "System" %}
            <input type="submit" class="btn btn-dark" name="forward" value="Forward">
        {% endif %}
    </div>
</div>
{% else %}
<div class="game-body">
    <h4 class="text-center mb-0">You have not got any messages yet.</h4>
</div>
{% endfor %}
    <input type="hidden" name="token" value="{{ token }}">
</form>

{% endblock %}