<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request" />
<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#020617">
    <title>MyTechStore | Hardware & Gaming</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        ink: '#020617',
                        panel: '#0f172a',
                        panel2: '#111827',
                        line: '#25324a',
                        cyanx: '#22d3ee',
                        greenx: '#34d399',
                        amberx: '#f59e0b'
                    },
                    boxShadow: {
                        glow: '0 18px 50px rgba(34, 211, 238, 0.18)'
                    }
                }
            }
        }
    </script>
</head>
<body class="min-h-screen bg-ink text-slate-100 antialiased selection:bg-cyanx selection:text-ink">
<a class="sr-only focus:not-sr-only focus:fixed focus:left-4 focus:top-4 focus:z-50 focus:rounded-md focus:bg-cyanx focus:px-4 focus:py-2 focus:font-bold focus:text-ink" href="#main-content">Aller au contenu</a>
