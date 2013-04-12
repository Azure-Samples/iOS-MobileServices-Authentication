function insert(item, user, request) {
    if (request.parameters.bypass)
        request.respond(200, item);
    else 
        request.respond(401);
}