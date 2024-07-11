from django.shortcuts import render
from rest_framework.views import APIView
from .serializers import UserLoginSerializer, UserRegistrationSerializer, UserProfileSerializer
from rest_framework.response import Response
from django.contrib.auth import authenticate
from rest_framework import status
from django.utils import timezone
from datetime import timedelta
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework import mixins, generics
from .models import CustomUser


class UserRegistrationView(generics.CreateAPIView, mixins.CreateModelMixin):
    queryset = CustomUser.objects.all()
    serializer_class = UserRegistrationSerializer
    
    def post(self, request):
        ser = UserRegistrationSerializer(data=request.data)

        if ser.is_valid():
            ser.save()

            return Response({"message": "Success"}, status=status.HTTP_201_CREATED)
        return Response(ser.errors, status=status.HTTP_400_BAD_REQUEST)


class UserLoginView(APIView):
    def post(self, request):
        ser = UserLoginSerializer(data=request.data)
        if ser.is_valid():
            email = ser.validated_data['email']
            passwd = ser.validated_data['password']
            user = authenticate(email=email, password=passwd, request=request)

            if user is not None:
                expiration_time = timezone.now() + timedelta(seconds=20)

                token_obj, _ = Token.objects.get_or_create(user=user)
                token_obj.expires_at = expiration_time
                token_obj.save()
                response = Response({'message': 'Login successful'}, status=status.HTTP_200_OK)

                response['Authorization'] = "token " + str(token_obj)
                print(str(token_obj))
                return response
            else:
                return Response({"message": "Invalid Credentials", 'token': str(token_obj)}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response(ser.errors, status=status.HTTP_400_BAD_REQUEST)
        

class LogoutView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # Get the user associated with the token
        user = request.user

        # Delete the existing token for the user
        Token.objects.filter(user=user).delete()

        return Response({"message": "Logout successful"}, status=status.HTTP_200_OK)
    

class UserProfileView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, pk=None):
        if pk is not None:
            try:
                user = CustomUser.objects.get(id=pk)
            except CustomUser.DoesNotExist:
                return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

            serializer = UserProfileSerializer(user)

            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)