{% extends 'default/layouts/loggedin.tpl' %}
{% block body %}
<ul class="game-tabs">
    <li class="tab-item active"><a href="{{ settings.get('website_url') }}inventory" class="tab-link">Inventory</a></li>
    <li class="tab-item"><a href="{{ settings.get('website_url') }}smuggling" class="tab-link">Smuggling</a></li>
</ul>

<div class="page-img d-none d-md-block">
    <img src="{{ img }}pages/inventory/header_smuggling.png" class="img-fluid">
</div>

<div class="game-body">
    <div class="row">
        <div class="col-12 col-md-6">
            <div class="game-header">Items</div>
            <div class="game-box">
                {% if items is empty %}
                    <p class="small">You do not have any items.</p>
                {% else %}
                    <ul class="statics-menu">
                        {% for item in items %}
                        <li>
                            <span class="static-name">
                                <i class="{{ item.icon }} mr-2"></i>
                                {{ item.item }}
                            </span>
                            <span class="static-num">{{ item.count | number_format }}</span>
                        </li>
                        {% endfor %}
                    </ul>
                {% endif %}
            </div>
        </div>
        <div class="col-12 col-md-6">
            <div class="game-header">Smuggled Goods</div>
            <div class="game-box">
                <p class="small">You do not have any smuggled goods.</p>
            </div>
        </div>
    </div>
</div>

{% endblock %}