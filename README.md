# Дипломное задание по курсу «DevOps-инженер»
[/olekirs/netology-devops ](https://github.com/OleKirs/netology-devops/edit/master/README.md)

## Дипломный практикум в YandexCloud

### Цели:  

<details>

  <summary>Подробнее</summary>  

1. Зарегистрировать доменное имя (любое на ваш выбор в любой доменной зоне).  

> Зарегистрировано имя `gw22.pw`   

3. Подготовить инфраструктуру с помощью Terraform на базе облачного провайдера YandexCloud. 

> Выполнено.   
> ![Панель YC](files/imgs/yc_cloud.png "Панель управления в YC")  

4. Настроить внешний Reverse Proxy на основе Nginx и LetsEncrypt.  

> Выполнено  

5. Настроить кластер MySQL.  
> Выполнено 
6. Установить WordPress.
 
> Выполнено  
7. Развернуть Gitlab CE и Gitlab Runner.  
> Выполнено  
8. Настроить CI/CD для автоматического развёртывания приложения.  
> Выполнено  
9.  Настроить мониторинг инфраструктуры с помощью стека: Prometheus, Alert Manager и Grafana.  
> Выполнено  

</details>

### Отчёт:

1. Репозиторий со всеми Terraform манифестами и готовность продемонстрировать создание всех ресурсов с нуля.  
>   [https://github.com/OleKirs/test-yc/tree/master/terraform](https://github.com/OleKirs/test-yc/tree/master/terraform])
2. Репозиторий со всеми Ansible ролями и готовность продемонстрировать установку всех сервисов с нуля.
>   [https://github.com/OleKirs/test-yc/tree/master/ansible/playbooks](https://github.com/OleKirs/test-yc/tree/master/ansible/playbooks) 
3. Скриншоты веб-интерфейсов всех сервисов работающих по HTTPS на вашем доменном имени.
•	https://www.you.domain (WordPress)  
>  ![Wordpress admin panel screenshot](files/imgs/wordpress_admin.png "Панель управления Wordpress")
•	https://gitlab.you.domain (Gitlab)  
>  ![Gitlab CI interface](files/imgs/gitlab_ci.png "Панель управления Gitlab CI")
•	https://grafana.you.domain (Grafana)  
>  ![Grafana Prometheus dashboard](files/imgs/grafana.png "Панель мониторинга в Grafana" )
•	https://prometheus.you.domain (Prometheus)  
>  ![Promrteus targets dashboard](files/imgs/prometheus.png "Панель мониторинга целевых систем в Prometheus" )
>  ![Prometheus alert message](files/imgs/prometheus_alert.png "сообщение об ошибке на целевой системе в панели Prometeus" )
•	https://alertmanager.you.domain (Alert Manager)  
>  ![Alertmanager status info](files/imgs/alertmanager_status.png "Панель информации о состоянии Alertmanager" )
>  ![Alertmanager alert info](files/imgs/alertmanager_alert.png "Отображение аварии на целевой системе в панели Alertmanager" )

5. Все репозитории рекомендуется хранить на одном из ресурсов (github.com или gitlab.com).
> Ссылка на репозиторий: [https://github.com/OleKirs/test-yc.git](https://github.com/OleKirs/test-yc.git)
