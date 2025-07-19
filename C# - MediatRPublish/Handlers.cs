public class GenericNotificationHandler
    : INotificationHandler<EntityNotification>
{
    public async Task Handle(EntityNotification notification, CancellationToken cancellationToken)
    {
        Console.WriteLine("GenericNotificationHandler received:" + notification.GetType().FullName);
    }
}

public class EntityNotificationForAHandler
    : INotificationHandler<EntityNotificationTyped<A>>
{
    public async Task Handle(EntityNotificationTyped<A> notification, CancellationToken cancellationToken)
    {
        Console.WriteLine("EntityNotificationForAHandler received:" + notification.GetType().FullName);
    }
}

//public class EntityNotificationForBHandler
//    : INotificationHandler<EntityNotificationTyped<B>>
//{
//    public async Task Handle(EntityNotificationTyped<B> notification, CancellationToken cancellationToken)
//    {
//        Console.WriteLine("EntityNotificationForBHandler received:" + notification.GetType().FullName);
//    }
//}