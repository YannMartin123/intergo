package com.ict4dg19.intergo.util;

import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class PdfExportUtil {

    public static void exportToPdf(HttpServletResponse response, String title, String[] headers, List<String[]> data, String filename) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        PdfWriter writer = new PdfWriter(response.getOutputStream());
        PdfDocument pdf = new PdfDocument(writer);
        Document document = new Document(pdf);

        // Title
        Paragraph titleParagraph = new Paragraph(title)
                .setTextAlignment(TextAlignment.CENTER)
                .setBold()
                .setFontSize(18)
                .setMarginBottom(20);
        document.add(titleParagraph);

        // Table
        Table table = new Table(UnitValue.createPercentArray(headers.length)).useAllAvailableWidth();

        // Header
        DeviceRgb headerColor = new DeviceRgb(41, 128, 185); // Custom blue color
        for (String header : headers) {
            Cell cell = new Cell()
                    .add(new Paragraph(header).setBold().setFontColor(com.itextpdf.kernel.colors.ColorConstants.WHITE))
                    .setBackgroundColor(headerColor)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setPadding(5);
            table.addHeaderCell(cell);
        }

        // Data
        for (String[] row : data) {
            for (String cellData : row) {
                table.addCell(new Cell().add(new Paragraph(cellData != null ? cellData : "")).setPadding(5));
            }
        }

        document.add(table);
        document.close();
    }
}
