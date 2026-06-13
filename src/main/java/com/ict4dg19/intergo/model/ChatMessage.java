package com.ict4dg19.intergo.model;

import java.time.LocalDateTime;

public class ChatMessage {
    private Long id;
    private String senderEmail;
    private String receiverEmail;
    private String message;
    private LocalDateTime timestamp;
    private String fileName;
    private String fileType;
    private String fileUrl;

    public ChatMessage() {}

    public ChatMessage(Long id, String senderEmail, String receiverEmail, String message, LocalDateTime timestamp, String fileName, String fileType, String fileUrl) {
        this.id = id;
        this.senderEmail = senderEmail;
        this.receiverEmail = receiverEmail;
        this.message = message;
        this.timestamp = timestamp;
        this.fileName = fileName;
        this.fileType = fileType;
        this.fileUrl = fileUrl;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSenderEmail() {
        return senderEmail;
    }

    public void setSenderEmail(String senderEmail) {
        this.senderEmail = senderEmail;
    }

    public String getReceiverEmail() {
        return receiverEmail;
    }

    public void setReceiverEmail(String receiverEmail) {
        this.receiverEmail = receiverEmail;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }
}
