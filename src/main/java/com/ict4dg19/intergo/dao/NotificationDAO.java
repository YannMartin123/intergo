package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.Notification;
import java.util.List;

public interface NotificationDAO {
    List<Notification> findReceived(String destinataire);
    List<Notification> findSent(String expediteur);
    int countUnread(String destinataire);
    void markAsRead(Long id);
    void create(Notification notification);
}
