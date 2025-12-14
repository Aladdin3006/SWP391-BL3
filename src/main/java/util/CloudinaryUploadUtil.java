package util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Map;
import java.util.UUID;

public class CloudinaryUploadUtil {
    private static final String CLOUD_NAME = "dacgihdpq";
    private static final String API_KEY = "325586116562688";
    private static final String API_SECRET = "iixvIKU4OqxPQUGgZUqjnOOFpXk";

    private static Cloudinary cloudinary = null;

    static {
        cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", CLOUD_NAME,
                "api_key", API_KEY,
                "api_secret", API_SECRET,
                "secure", true
        ));
    }

    public static String uploadImage(Part filePart) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        Path tempFile = null;
        try {
            String fileName = filePart.getSubmittedFileName();
            if (fileName == null || fileName.isEmpty()) {
                fileName = "upload_" + UUID.randomUUID() + ".tmp";
            }

            tempFile = Files.createTempFile("cloudinary_upload_", fileName);

            try (InputStream inputStream = filePart.getInputStream()) {
                Files.copy(inputStream, tempFile, StandardCopyOption.REPLACE_EXISTING);
            }
            Map uploadResult = cloudinary.uploader().upload(
                    tempFile.toFile(),
                    ObjectUtils.emptyMap()
            );

            return (String) uploadResult.get("secure_url");

        } catch (Exception e) {
            throw new IOException("Failed to upload image to Cloudinary: " + e.getMessage(), e);
        } finally {
            if (tempFile != null) {
                try {
                    Files.deleteIfExists(tempFile);
                } catch (IOException e) {
                    System.err.println("Failed to delete temporary file: " + e.getMessage());
                }
            }
        }
    }

    public static String uploadImageFromBase64(String base64Image) throws IOException {
        if (base64Image == null || base64Image.trim().isEmpty()) {
            return null;
        }

        Map uploadResult = cloudinary.uploader().upload(
                base64Image,
                ObjectUtils.asMap("resource_type", "image")
        );

        return (String) uploadResult.get("secure_url");
    }

    public static String uploadImageFromUrl(String imageUrl) throws IOException {
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            return null;
        }

        Map uploadResult = cloudinary.uploader().upload(
                imageUrl,
                ObjectUtils.asMap("resource_type", "image")
        );

        return (String) uploadResult.get("secure_url");
    }

    public static boolean deleteImage(String publicId) throws IOException {
        if (publicId == null || publicId.isEmpty()) {
            return false;
        }

        Map result = cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
        return "ok".equals(result.get("result"));
    }

    public static String extractPublicIdFromUrl(String url) {
        if (url == null || url.isEmpty()) return null;

        try {
            String[] parts = url.split("/");
            String fileNameWithExt = parts[parts.length - 1];
            return fileNameWithExt.substring(0, fileNameWithExt.lastIndexOf('.'));
        } catch (Exception e) {
            return null;
        }
    }
}